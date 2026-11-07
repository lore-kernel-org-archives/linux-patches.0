Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063276;
	b=Uq9yF3Jgv9bo5Gv14anubTUq+0TaWclzgV9CSS5WFlyust582k9FEBc0wCB+0+ZXRpBV
	 Yo7b1FHM6FjvsaxNjRVlPpwzogH8r4r+/DZD3PgedCyZ4Stypgt0cHK4GQZrM/T65U+KU
	 VExZu3ZoLNwTJbu5mEfHdz2QmWTRrWcPdHBXuB+A/LhIy2CRgNYHewek78HA8FUz2xE3n
	 26ryLH6nc20ZYGKDae6axKrlRzxtdb5MIOhsxFI7gteyKYkcxeOP1Yx1b3dhWGXss33LI
	 hD4REYXtBYIqE77UIG7KIEyhSEUfXzrviHS0AOWedfMKniUxsHL3Djstga+f/Q622Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3vXjwtzG4m44EBVKgQD5LYHrNo/mCJuQ6NS26APexAQ=;
	b=wMQG8Jb9QvR31sku5dCsY9AKJq+4kd2MFEHMaeBpQztdxJ7e/HcU6r1JQwBGTgbsOFLo
	 L3lJRwxx/9+XS2sXqqc1SPi5u1tp4UAmYOA96Mn+loEsJVjEWFysO+xjnTZDVSOJptrHG
	 H4M35KGjmTMxCLXRdyuzQdDR3MmHeaLCEZ8XlOuR80G1taycF/G7WRbRR7BBkMRoacQ1N
	 iDokdGlWSd/XoklTYRdtv3ZQrnArKvD6c7+K4CoiaG6jaa+LBBU/mp2r5S18+CLC6D55W
	 LS/NyT07a1hgHa0BNMslSMbLm2I+ZpRnm/INVIE6qIef23lv24Q/ZdJ3XzEgOO4Gb5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tlsMkFX/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B74606A337;
	Sat,  7 Nov 2026 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlsMkFX/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C4A1F0089F;
	Sat,  7 Nov 2026 14:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063276;
	bh=3vXjwtzG4m44EBVKgQD5LYHrNo/mCJuQ6NS26APexAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlsMkFX/hAQhhJpc0skl7nOrmCrKW7TaWKUArUp0YAp5d4aPDLvahxkRSFUU9Bhsm
	 9V9EE8f2oVOkHQVFjsuGVTQeuKp/BjrRf7f+B/N9Tklg2Di1mKuDtmlUTXlsRQOniz
	 F4B6mUWvx+a5c3HK0/AGfDRn6ZANlkMua9gOMF18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Hengyu Liang <hengyul@cs.unc.edu>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 472/869] btrfs: return -ENOTTY for unknown ioctls on the control device
Date: Sat,  7 Nov 2026 08:52:34 -0500
Message-ID: <20261107134909.628407144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit 9985f1643ac3f8595862e2f82108f0ccae4cf959 ]

Commit 5ab2b180884c ("btrfs: factor out validation of
btrfs_ioctl_vol_args::name") made btrfs_control_ioctl() store the result
of btrfs_check_ioctl_vol_args_path() in ret before it looks at the
command.

However, ret is initialized to -ENOTTY and the switch has no default
case, so this initial value was what an unknown command returned. As of
now, every unknown ioctl on /dev/btrfs-control returns 0. A tool that
tries a control ioctl which the running kernel does not have is told
that the ioctl succeeded.

The issue can be reproduced with a simple C program, run as root:

    #include <fcntl.h>
    #include <stdio.h>
    #include <sys/ioctl.h>

    int main(void)
    {
            static char buf[4096];
            int fd = open("/dev/btrfs-control", O_RDWR);

            if (ioctl(fd, TCGETS, buf) < 0)
                    perror("ioctl");
            else
                    printf("ioctl succeeded\n");
            return 0;
    }

Before commit 5ab2b180884c ("btrfs: factor out validation of
btrfs_ioctl_vol_args::name"), the result is:

    ioctl: Inappropriate ioctl for device

After that commit, the result is:

    ioctl succeeded

This patch will add a default case that returns -ENOTTY.

Fixes: 5ab2b180884c ("btrfs: factor out validation of btrfs_ioctl_vol_args::name")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6cc4fe2ccd8a7..61a0575fd162a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2284,6 +2284,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		ret = btrfs_ioctl_get_supported_features((void __user*)arg);
 		break;
+	default:
+		ret = -ENOTTY;
+		break;
 	}
 
 out:
-- 
2.53.0



