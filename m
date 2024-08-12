Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E224183CA6;
	Mon, 12 Aug 2024 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479844; cv=none; b=mIe7p2k8wg0/O2b00f71Wn1XM8Uyp0ko03goJmJWBk71WwWEReEBA8OmXvYr3KyR68J/1xB2rQ3GCSyH6ld8XWduy6aubNQjjlVldPPInL2Q8+Teq4UlNimmci6wVWxsL9VM4QTsVmKdmKFX67iLQ8uPTiMngAqCZqD0M7XVmZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479844; c=relaxed/simple;
	bh=+J288NQhwu/yk+2sxt69zJWGsi2Al6rhYeSI7Z/XOIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HhmI3+77z5E87xA/a4Np6KeR3dK9Iq/otWHQASvfsy329oVM2L++xCAS6ZKv/z4lT5CSjY4I+wqThiRobbA/ck1NuzatPk1F5UWonMc7NAQSvmV22clbGMltLuco3JYcIMItnqcYVLgrdEXyLxJF1OJNo4SbJFZRbqvVEQL+lN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HE9rvTjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HE9rvTjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61F2C32782;
	Mon, 12 Aug 2024 16:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479844;
	bh=+J288NQhwu/yk+2sxt69zJWGsi2Al6rhYeSI7Z/XOIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HE9rvTjxz21/rzz1ZfZhdYMChYmYiWLIYffjVwn1Zh4Zywj2UF2UO/b/OxyFKrbfY
	 q2lLV8eny7QQRTyL9TTw9TQouA9+TAL/djUZe2M2tcvpPmlgZ5XuEo9LMYtM5JkIZI
	 Guov11sJjPtah+mEeVRHHwpVyGkjF9i8n/CZErBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jithu Joseph <jithu.joseph@intel.com>,
	Ashok Raj <ashok.raj@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 008/263] platform/x86/intel/ifs: Initialize union ifs_status to zero
Date: Mon, 12 Aug 2024 18:00:09 +0200
Message-ID: <20240812160146.846148049@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit 3114f77e9453daa292ec0906f313a715c69b5943 ]

If the IFS scan test exits prematurely due to a timeout before
completing a single run, the union ifs_status remains uninitialized,
leading to incorrect test status reporting. To prevent this, always
initialize the union ifs_status to zero.

Fixes: 2b40e654b73a ("platform/x86/intel/ifs: Add scan test support")
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://lore.kernel.org/r/20240730155930.1754744-1-sathyanarayanan.kuppuswamy@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/ifs/runtest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 282e4bfe30da3..be3d51ed0e474 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -221,8 +221,8 @@ static int doscan(void *data)
  */
 static void ifs_test_core(int cpu, struct device *dev)
 {
+	union ifs_status status = {};
 	union ifs_scan activate;
-	union ifs_status status;
 	unsigned long timeout;
 	struct ifs_data *ifsd;
 	int to_start, to_stop;
-- 
2.43.0



