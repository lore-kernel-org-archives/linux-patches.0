Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139F1222D45;
	Thu, 12 Dec 2024 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025880; cv=none; b=mqrIArJuEkDDoBrQiWk58PoZltUU/QO4OJVrSrfRkiqgWmsxfcKrj3NbsuCn3bB+P9ZVGc6v0QaVdPL7iP/mYrryIJG3r3+0G7rjHgtLu23CVx6bkR40N29IFmyFaKsazZUo8tklg/tdn11m+bQqyh7RBalI6GRBj8X+PeQ2txU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025880; c=relaxed/simple;
	bh=+EwDCjYvmwCd16l6ojyskEA/umRpPfSp166gYyr4Jbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8BJaDinn5Wn2PAL3gP/wU41OmhtIJK2OAHLYM6vg0SPe3TsGI1vNsNzKOUamZZZjE8MTwEw0PQbDl78BDWDLuhTjcXk/nFenvAN/xgucefRujObSu7Pohfn1nlTq4+ouz1xw5mT114A9Lx2bpKAlVRss6BkKAu4eU8p4wf6tzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWhiPiqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWhiPiqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC22C4CECE;
	Thu, 12 Dec 2024 17:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025877;
	bh=+EwDCjYvmwCd16l6ojyskEA/umRpPfSp166gYyr4Jbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWhiPiqHKxVnsU+LRdVNQ3jfpqLaUZGz9YcyD1zbGocV9A8LDPHh2iiwrCEs8gcaI
	 ztG55YGbMClE4ubqM16q+xFLgLDeRcy4gbBGbOh+NZ99c5qv4ubeppuMO4EH+PuXUM
	 2c8b0lQfTitJP14ZqnXpu8T4FbbP0ryFTmJjwiw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>
Subject: [PATCH 5.4 318/321] Revert "drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()"
Date: Thu, 12 Dec 2024 16:03:56 +0100
Message-ID: <20241212144242.543433369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

This reverts commit 7ccd781794d247589104a791caab491e21218fba.

The origin mainline patch fix a buffer overflow issue in
amdgpu_debugfs_gprwave_read(), but it has not been introduced in kernel
6.1 and older kernels. This patch add a check in a wrong function in the
same file.

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -395,7 +395,7 @@ static ssize_t amdgpu_debugfs_regs_smc_r
 	if (!adev->smc_rreg)
 		return -EOPNOTSUPP;
 
-	if (size > 4096 || size & 0x3 || *pos & 0x3)
+	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
 
 	while (size) {


