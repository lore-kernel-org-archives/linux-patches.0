Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D87B263F4D;
	Tue,  8 Apr 2025 12:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115021; cv=none; b=nTIqR2ncS3s79WBJzjaDnk832lu0n9X3sRNrSJNzS3X6GDJnLTwg0RKdoRtA4g/GwPp5TH5Jp6lv/gycvVzKpJejwyarkj/NzYPjmO1Z+SRv3JLcLBNKsYLWRKrFJuNhcHwqrnsOrNh2+cwYvGdPmWjiDD12aOHRTyzyW3zOFSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115021; c=relaxed/simple;
	bh=hf3SVSvZlafF33Kl5bmgkiz4imZ2k0NMsdTGh1bhSKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CAJ1wUMIbQNYuB+wPA64Bohwr9KIdgyw2XK19QlNQRFTtP0mET8qCI7rQ94fC8UPaMOJhUgOgW35o7aZaSmkYeA9PY81BL/2SVkISFpbUZIkvZdERXKC/DyN5Wrdu/MSq3stKbkMV48jj+3KaahZpLyR7zA4ZY4mnjtK/NoSDrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6n4TSDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6n4TSDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F82FC4CEE5;
	Tue,  8 Apr 2025 12:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115021;
	bh=hf3SVSvZlafF33Kl5bmgkiz4imZ2k0NMsdTGh1bhSKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6n4TSDgps40FOhL/Y9mUWzEMfPk/blGmEOrVXr3esUPvJYX4CBJxh6Aa/1xeY+i7
	 JvrenwQkHHqAoKv1pLA+wwTHY+yQBxGLozNRLOpY34M6IL/15HRfpSnz7NwYDkAXxl
	 5l7etuxmkX8isNKvWXjTdP0jjje6Ix1DHKh2zgVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 320/499] platform/x86/amd/pmf: Propagate PMF-TA return codes
Date: Tue,  8 Apr 2025 12:48:52 +0200
Message-ID: <20250408104859.206076184@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 9ba93cb8212d62bccd8b41b8adb6656abf37280a ]

In the amd_pmf_invoke_cmd_init() function within the PMF driver ensure
that the actual result from the PMF-TA is returned rather than a generic
EIO. This change allows for proper handling of errors originating from the
PMF-TA.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Co-developed-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20250305045842.4117767-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/tee-if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmf/tee-if.c b/drivers/platform/x86/amd/pmf/tee-if.c
index 8c88769ea1d87..b404764550c4c 100644
--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -323,7 +323,7 @@ static int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev)
 	} else {
 		dev_err(dev->dev, "ta invoke cmd init failed err: %x\n", res);
 		dev->smart_pc_enabled = false;
-		return -EIO;
+		return res;
 	}
 
 	return 0;
-- 
2.39.5



