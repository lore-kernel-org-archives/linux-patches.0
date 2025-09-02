Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9946D30DD30;
	Tue,  2 Sep 2025 13:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819781; cv=none; b=Fd4bcQ2rFYYd2PsS+1vJqt91RKdqAX0Dfl3RJ8K0ZcFAP6e2hs/Lm7iVkw/+torQIJjPxluRvM9JhR305Y8F42Zk7xRABYWFUm5rbndrn+ugci9hW+vthwjvkmtnHbx4Fbtz51g6pxQ8kXz9RkIXnRJKZUU7BtLJfqyqY5gjmZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819781; c=relaxed/simple;
	bh=QAE6rdqjvl0sxj35epr10rCoN8FmqbqZfqg9XrJRVcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVSSnXq3xYQ9i0pvuB8RUrN8wwQqXVARgLyRFmCkb4t8LoLIa+vnVZyUCZ20TbThAkLzzu+TZzgBY/iFUxxZ2IZb0NukuYAzPLZC+MBbFIlzu5tcS1bTpBp/3ocs070ihoLs9P8PINohGHhYmFMYh2e3eAkBg3dwyWSocjJUD7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qaHkCDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qaHkCDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B15C4CEED;
	Tue,  2 Sep 2025 13:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819781;
	bh=QAE6rdqjvl0sxj35epr10rCoN8FmqbqZfqg9XrJRVcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0qaHkCDhn/EOB5ADWPEDfEE8M8YUfvFeRgHgYjdkC2lo6dk5IusjqQMO/2k9WNPpU
	 HCsul4LEkjjYANx8a5DWjJo2+oLyqWJ8WBhMr+ACdBFSVaVOFHq0K1rr1zZERlspWb
	 nwdVk5iliNiZk/WxcWRTwPShlRvdz4A8k280bGqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 130/142] drm/amdgpu/userq: fix error handling of invalid doorbell
Date: Tue,  2 Sep 2025 15:20:32 +0200
Message-ID: <20250902131953.265156911@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c767d74a9cdd1042046d02319d16b85d9aa8a8aa upstream.

If the doorbell is invalid, be sure to set the r to an error
state so the function returns an error.

Reviewed-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7e2a5b0a9a165a7c51274aa01b18be29491b4345)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -426,6 +426,7 @@ amdgpu_userq_create(struct drm_file *fil
 	if (index == (uint64_t)-EINVAL) {
 		drm_file_err(uq_mgr->file, "Failed to get doorbell for queue\n");
 		kfree(queue);
+		r = -EINVAL;
 		goto unlock;
 	}
 


