Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064639;
	b=xxBXzzziTHwxU3Q7KKGE/FLI52hyw4ufgGShZLvkuo5D4MQl8tXImoAf+0GFW7dOaFZ2
	 6d+ta4pDhBZSoTVhfmxL3AuSx0xQ/NARzbZ/jiGC9lvJehghNFbGg4ad1yD8WEwgzdAWn
	 QV8+GaMrVs5reOIMbVxMKh5AvABsEyr0y1lr1Pk3uSM0yYH9ZBvn07zNQWR5rTeq6SHgi
	 foM4yhdO7VY1u7k1HCRjhV2x+1Ncax/zzU6e9bDPrJ4WvI9VPClNMkRCJ/SY4t1OWeKNP
	 aY7lVDRVLfbBWLvtIL+ugeIaeczetsZ3MZ2UPh6z0WnvIJ+8GU5iifleyY23GrFcWKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rFAh4fhFgav3l7Sr3lLD1Nbowio+9qAvMvvM1T+luLA=;
	b=4QYLLVx2RBNjZFgu5l5On/4PuRUzb+UypVmNpWntmSt4zYtarZDqgDUjssZQhTRgT2KT
	 EoVO86HcKCJqzYx4IOy/m3N2xA18CogInXjU3WRQsbiK/x/jVhqqV3L4/pvxWpyPpz0Dl
	 gE55TA53FvdSOHymbZB1q5vXPGgLvmNNzALCuB7JRZbZ7c7lV352sjQsR6/m527VyswYi
	 0vFKcacKCXOepx2lpjC9VRBLaV+E2YKP0tNab6cMoixpVjP4APNxwQDksXXTFWhVFmsCM
	 74opjcBCSw17djDa+WSaBUXQ6sMejyd2ZIUidGo3Cjc++qPatF8Ul2i1JxW7tkM/swg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GOAlDWI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3D2606A33D;
	Sat,  7 Nov 2026 15:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GOAlDWI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6DB1F0089F;
	Sat,  7 Nov 2026 15:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064639;
	bh=rFAh4fhFgav3l7Sr3lLD1Nbowio+9qAvMvvM1T+luLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GOAlDWIdrPoLCm6sndy8i+dDxyqU8TAqLIZQvBAp3sw2T7xAHqaX0FXeYbtKcpjj
	 sJkMGk85GTmvjvI5MWTLk6RYQRLTIsrZXCnUkMaoX5iKIUty3XcBQw2WhrYVNmfXfd
	 i+np0epbGNl5UyqwWoGZLOxtXypysDoQSWbty5Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Hengyu Liang <hengyul@cs.unc.edu>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0644/1257] btrfs: return -ENOTTY for unknown ioctls on the control device
Date: Sat,  7 Nov 2026 08:49:00 -0500
Message-ID: <20261107134957.060886575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ddb620ac241b4..2c9b29aa59a2e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2305,6 +2305,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
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



