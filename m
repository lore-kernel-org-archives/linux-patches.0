Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A631494A8;
	Fri,  6 Dec 2024 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496404; cv=none; b=KpYjwo210TqSgEJZDnw5LpChWe/BU2zMMiIyJ91tVi8Uln6QXbF64F780ZizW7IanyXYCwK1MsbZ18LzUlIVChAEXCOQ4ZSWrSGqDjrLlJBwuGht3VVu2BvRcdhewZXay3QFPdOLglV2ggbTZO/N/wHBNmcSwIPc4xd7QdXGzlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496404; c=relaxed/simple;
	bh=J1xiyrzWQtQq2GEvuoMWf2dH/rz2uLWMmvTONA39mZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBLHp/ArwXgeIb5PUV6HdY6ez9zey56L6id2d6kZGr4NSk8YvZoYPo+E77PvgNB9n027KySPWpI4zU8pXVE9VWhPuIEsYKVA9fi1u8fEtFTrgDeESyzNVfkpkpTbhIishNtyAsLK6ibBb01TIF5Sry0YsE48aQIazE3FmZssl1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb8n4I2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb8n4I2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7F9C4CED1;
	Fri,  6 Dec 2024 14:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496404;
	bh=J1xiyrzWQtQq2GEvuoMWf2dH/rz2uLWMmvTONA39mZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tb8n4I2lEs/3ispnTb+T3r5T57wORH/9JM/D4E/t5g5UWOcrAhCllnL3EHDO/hY3c
	 7lEsacyAmUVYLJEa+6m80v+y8kHOKDnSSQLQYY/2yXld8Oq1o7rzWQVM7m5VdhzbBv
	 jtTeCooF5FQbHdtkS6QBW9wyhyGFvPTsJoZUbw30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 142/146] drm/amd/pm: Remove arcturus min power limit
Date: Fri,  6 Dec 2024 15:37:53 +0100
Message-ID: <20241206143533.121817416@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit da868898cf4c5ddbd1f7406e356edce5d7211eb5 upstream.

As per power team, there is no need to impose a lower bound on arcturus
power limit. Any unreasonable limit set will result in frequent
throttling.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1344,8 +1344,12 @@ static int arcturus_get_power_limit(stru
 		*default_power_limit = power_limit;
 	if (max_power_limit)
 		*max_power_limit = power_limit;
+	/**
+	 * No lower bound is imposed on the limit. Any unreasonable limit set
+	 * will result in frequent throttling.
+	 */
 	if (min_power_limit)
-		*min_power_limit = power_limit;
+		*min_power_limit = 0;
 
 	return 0;
 }


