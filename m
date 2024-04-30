Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D86412C490;
	Tue, 30 Apr 2024 10:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474504; cv=none; b=EVCasjK9pAMuZx4ite0AoAdUL8Yq2y7M+xC/FlrIhHzC/famQW9/40u4GbYPW2xtZjtxQZIE9UO2FyqU5bpEoOMQMJz/bfuxXixRIqyN9lgk/svfrGqjUqDn6BMeo5Gowv1olyTsSbKYlRrhGcx/NfMvw7gNCQtfFbnji8JDIxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474504; c=relaxed/simple;
	bh=HEeZVxbM7oxl7ZHHsxL6Mp13JDhMCt8q8uamKoamjvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHDsr8NvsBolt1HaEOdzC92BE4rYihSj4pO1O7ZD7e8BaOstdFxEFQvDg6aD0pFMf8l+BTSs8Ha6SdjvTOkOLiL5UD+EJ7EpD8V8iaIylrdx2djX9ytItlEadQpr0akfGZxoMsjAFAEUB+Ao65uv5aOnppYgZWba4wojfxxF+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK93zh2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK93zh2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AB4C2BBFC;
	Tue, 30 Apr 2024 10:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474503;
	bh=HEeZVxbM7oxl7ZHHsxL6Mp13JDhMCt8q8uamKoamjvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK93zh2vXokOJxKaBmddk2sYrErA3glDw8so6jbCcXqbusD79egDbKU3wHhEW8hgy
	 TgXAxO9p+p3n2PTtqmX7gcCY4BJXw9snmcBxa8ZIXri8Ok46YaltXgYevxv7shiClT
	 7TqBhKiLjw22CoH6VLWx7ajw8rSvUwH+xfK5IhIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 176/228] drm/amdgpu/pm: Remove gpu_od if its an empty directory
Date: Tue, 30 Apr 2024 12:39:14 +0200
Message-ID: <20240430103108.882900901@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

commit 0e95ed6452cb079cf9587c774a475a7d83c7e040 upstream.

gpu_od should be removed if it's an empty directory

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reported-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -4217,6 +4217,13 @@ static int amdgpu_od_set_init(struct amd
 		}
 	}
 
+	/*
+	 * If gpu_od is the only member in the list, that means gpu_od is an
+	 * empty directory, so remove it.
+	 */
+	if (list_is_singular(&adev->pm.od_kobj_list))
+		goto err_out;
+
 	return 0;
 
 err_out:


