Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56FB33B971;
	Tue,  6 Jan 2026 18:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722508; cv=none; b=GIVK4hrnyU2AiMZUVU1SxTh0jaYXL3yodUvVbod2YYhLeQGVdl6BQSPQG3DH9zIOGsWynb6E7i/lIraJfykz8RN0M7qkj3ZWkz6ruNKBVnf6XQ8VygCLSu3L5KETGq1OtWPKY7yWcC87EowoK2he49KbC6PanFkvTtaxib+Disg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722508; c=relaxed/simple;
	bh=0xsoAv5rhC4ReGiBMGap5/Ici8Fqd089PZxuPSj3DNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juCv9X3m4PW6CC/5rSjKj9+wdjJrRygikiklrqkcFRl6zCNtEvq57tz0qhcBXz5QBl3FFtiMFInzcmXw4hxDbsHQ1SYZdLYTNOQnDvSm3VBJvNilsqwuxqMYCFrI0m+vHNix5xXkfn8zW1h8CcuHYOg2LSMq70Sb6SKEhCGzfkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Jb3yREX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Jb3yREX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E85C19423;
	Tue,  6 Jan 2026 18:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722508;
	bh=0xsoAv5rhC4ReGiBMGap5/Ici8Fqd089PZxuPSj3DNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Jb3yREXvmtTorQlfWpU689tudT/++BOYeMGD/TZ/DOmLlvnOMATNTQUUgLNHRbTK
	 73rYsmZj1aJo8CImS0iXsFQ4a9r8heWRuKZVJmV67nSZ6CBBemOa5oRWTmKtEhL7/L
	 DlVS4vXG5cleqFV7g1o3mUAQhYL3W/2FefWCKYKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 285/312] drm/amdkfd: bump minimum vgpr size for gfx1151
Date: Tue,  6 Jan 2026 18:05:59 +0100
Message-ID: <20260106170558.164519242@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Kim <jonathan.kim@amd.com>

commit cf326449637a566ba98fb82c47d46cd479608c88 upstream.

GFX1151 has 1.5x the number of available physical VGPRs per SIMD.
Bump total memory availability for acquire checks on queue creation.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b42f3bf9536c9b710fd1d4deb7d1b0dc819dc72d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -409,6 +409,7 @@ static u32 kfd_get_vgpr_size_per_cu(u32
 		vgpr_size = 0x80000;
 	else if (gfxv == 110000 ||		/* GFX_VERSION_PLUM_BONITO */
 		 gfxv == 110001 ||		/* GFX_VERSION_WHEAT_NAS */
+		 gfxv == 110501 ||		/* GFX_VERSION_GFX1151 */
 		 gfxv == 120000 ||		/* GFX_VERSION_GFX1200 */
 		 gfxv == 120001)		/* GFX_VERSION_GFX1201 */
 		vgpr_size = 0x60000;


