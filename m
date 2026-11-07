Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062296;
	b=NcO6TWSAe8nXQhYOhdFy3X9O0AFHwmvr4927x36fFz3X1KTY4Ud7znZN3+lOGjV2VSFQ
	 LX9qMhp23TJwuyNo7QoF2gF98cudBZMwQP9RJxJRTyb99Qi8/oGL/xYGPTyPymEHMvYkf
	 7X1PcFdNx+VGbG4RlVV1khVQUv21uDWt5aOI304ZUjIaMoyIPlloF3WgaQfUxlGCZEL2L
	 Z4LoiYvCUAfrewtHFD355lVQdedxkPve6ZBSFmVZTvnq8Br7cApwm1rmVY57NAXNRtXsz
	 sYT1rjtIFHwEY5J75d49aBPa/XdFlKSsLFF5vedVp1PkftR2Zx/uySUoStpQoiRlBHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v7ZwhupHFeM0geKmqYBePrWYK+7YKZTZXM2HjlEsn8Q=;
	b=aEp7HzGKngL/vXXyKPoNcQ+nG7KlVA9Q7ob2SZMxljlqlMRm8dHhopdyVs5IzkmsXpAC
	 y8KPLAAVgYoIK1PVRG/MHb4bVWWFOS04D6moDoE7iRhm5v+FTUAkX03tm63yVjFaokDfH
	 VzUMotdFfSQyrpZ04vQBbw442GcPBZktp7ABsyWGptKxgo3ocOP3oqxuoI2hs/Q7l1ZBc
	 XRyp7Hl7gG6JZOg0c+n9V8zWu/fIJ4BXA2Ypcm4g4cCxFQYIPYg4QH3SSgS2tescP+Swh
	 UvuI3GFkX+JXS0A+wQgy8Sm7BYp5V79x5pXt/uWBsi327JGnxvkT+PGW62zCe20TyWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W/pXKmkX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEAC606EE98;
	Sat,  7 Nov 2026 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W/pXKmkX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F072E1F0089F;
	Sat,  7 Nov 2026 14:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062296;
	bh=v7ZwhupHFeM0geKmqYBePrWYK+7YKZTZXM2HjlEsn8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/pXKmkXfVqoLl9ObffSOearr7Zk9JHU1pLraxubxSantApQieIPzWBGxEKtY7amv
	 Ak272dFJBZMJMJe4WlJflgKVdUtRH2sp6A414IgGylGthwP764eZSV69SGtWscpAGb
	 Bt4EZWhk7FHw24gYSxiBsX6bPgJtE50V7uFmIGfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Hengyu Liang <hengyul@cs.unc.edu>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1232/1536] btrfs: return -ENOTTY for unknown ioctls on the control device
Date: Sat,  7 Nov 2026 08:54:08 -0500
Message-ID: <20261107135032.360830728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 62366d3fdcc63..60f2145c8ac8e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2265,6 +2265,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
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



