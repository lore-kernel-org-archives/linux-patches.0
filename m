Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96941FCF7D;
	Fri,  6 Dec 2024 15:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498003; cv=none; b=ipetK/yjC+Covf9/bznqgr2k1IfdWdaSchUlL4aE0EZtJ6CqqJTTQrvijr4fQDsI8TxVrQxncvQklWGdG1uv51pEbKXH/8fRqydJMIg8z9PCwK+4/kBveJuL8ETXT9XWdKdIludUMg83TGbQ5U5qB6ed43URwGJaBwCdcdlT8FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498003; c=relaxed/simple;
	bh=NNCG6FO1dBvIE8Cs9ES2iZI848CLn4qkyY5/PJI9nP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIIFm2ezCiD2RQ4uxCSOqk2dtmifv/Vd0ce6JXmcITJBZcznFuvS+ahwr+DeK9o6m0Aq97INm5Ep06+Mvk45jiltWMioCm1lYUGaFQ5MsCyR+K2hmHH94bmZzxLe/KfVeOs404k5MLVIS3VYQTA/idf46wCzaM5cB4ijF9/PV9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02ahwNW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02ahwNW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7BCC4CED1;
	Fri,  6 Dec 2024 15:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498003;
	bh=NNCG6FO1dBvIE8Cs9ES2iZI848CLn4qkyY5/PJI9nP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02ahwNW7aViLH2jLC0TzLjhm2ZpkQS8faeiQPx+5fDzPufW9XEXhA+wAb4YBlNBlf
	 Uq1qCjuUt7IjDlXaG7KNnRgMQfna3A0VB0VpJprL53bR4WzKNIkf+fHz5I4F3+9VVL
	 5jOZTq/26PVUB7Xdtb6LALhOdvLB+v1i8jVRULgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.6 458/676] drm/amd/display: Check phantom_stream before it is used
Date: Fri,  6 Dec 2024 15:34:37 +0100
Message-ID: <20241206143711.258408681@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit 3718a619a8c0a53152e76bb6769b6c414e1e83f4 upstream.

dcn32_enable_phantom_stream can return null, so returned value
must be checked before used.

This fixes 1 NULL_RETURNS issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Xiangyu: BP to fix CVE: CVE-2024-49897, modified the source path]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1786,6 +1786,9 @@ void dcn32_add_phantom_pipes(struct dc *
 	// be a valid candidate for SubVP (i.e. has a plane, stream, doesn't
 	// already have phantom pipe assigned, etc.) by previous checks.
 	phantom_stream = dcn32_enable_phantom_stream(dc, context, pipes, pipe_cnt, index);
+	if (!phantom_stream)
+		return;
+
 	dcn32_enable_phantom_plane(dc, context, phantom_stream, index);
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {


