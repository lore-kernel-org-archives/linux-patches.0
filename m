Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212285;
	b=reNh7JsfSU/AhS1igHvUfbQ3Zg+fCS16dbe/Oy0JHxmqMBYMoaAKGG6H16ndOuxf9iSX
	 Dx7IH0ZBBxgURjiLqM20QrtQtoNs45sMTdBuRpQMDr5qDSWvyYXuLwEQubdtgo8/ROoin
	 ZaTEDwXb0NdSa263EGobGD4yB9OkbcRObiXRmU0dNIuKYviPmJQUDdM6lEwlQj4n/fzqU
	 p+96rkHJcON59pW6vKfXftfUsa1UPPGcbZSwReL6yW03mGd3rIZ1sO3/loUFj82dWC9j7
	 Zl8t46okHi3hto9RvJT4NLNkQLIXz/tc/NxpSJ9wzqiiAoVuaPKGpkxV4J/saEw7aCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AQUzwAKYnWQjh9JgGvWYMeW6TxQla6wgq3L8vP/guW0=;
	b=EkmrylQkIX9hcuf3+qBsTCT6zV9ffniWr6CarXic8QR5S7GvGwdoCTHn5sWQ0X3ENRx1
	 azxdwHoG+AEs4jEI4nzN+LySOVCWTWV6J1xyYoDThZVrNWiDpk231SCQbx+rh1FCnQjW4
	 F77TfzNUce+P71Q7rQaCpGbQwlYTBA21XNwlKNmDiYgIRD3SU05geMRXUy1vDxyYZrBLG
	 1IcvTcH18kTx/YcW/dvSY5RcrCOufSh8PfHYX+w+evBH/QtMU7+DYf+2af34aefb/1YHR
	 iENGQH+tBB3nxpADf0E+xVpZUAz+sw18EWBfYual+Nkk04qo4LqgSm/VjMgMUPARqoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wM9d5RwW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3895F606A31C;
	Wed, 28 Oct 2026 18:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wM9d5RwW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341831F01825;
	Wed, 28 Oct 2026 18:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212284;
	bh=AQUzwAKYnWQjh9JgGvWYMeW6TxQla6wgq3L8vP/guW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wM9d5RwW1GSnGq30d0lDWyaT9KHxDZMaT7Or7rtc5zPtvz04Ylf+LiDdqvhdNlbIC
	 T7Bb6mqx1bS1qF1wpW9bRaUwO2ba/BPSWm9azuFZm3P1UfVPpim5eutWztHtWUQzDF
	 mg63RVHmLiqmr8Sucsn5k6YlPatOaTuAY4MwTzzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0065/1887] nfsd: release path refs on follow_down() error
Date: Wed, 28 Oct 2026 17:36:01 +0100
Message-ID: <20261028170500.710768287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

[ Upstream commit 6cba08dc1922140d260cfeb30bbda4ee1bf869d8 ]

nfsd_cross_mnt() initializes a local struct path with mntget() and
dget() before calling follow_down(). On a negative return the error
arm jumps to out without releasing those references:

    err = follow_down(&path, follow_flags);
    if (err < 0)
            goto out;

follow_down() never drops the caller's entry-time refs on any error
sub-case; for example a pre-cross d_manage() failure leaves path
untouched, so the mntget()/dget() taken on entry survive the call.

Every other early-exit arm in nfsd_cross_mnt() (other-namespace
return, IS_ERR(exp2), and the success tail after the swap) already
calls path_put(&path); the err < 0 arm is the lone omission. The
leak inflates mnt_count and d_count on each failed cross-mount,
blocking umount and pinning dentries against the shrinker, and is
reachable by any authenticated NFS client through nfsd_lookup_dentry
or the NFSv4 READDIR encode path.

Fix by calling path_put(&path) before the goto out in the err < 0
arm so the entry-time refs are released on all follow_down() error
returns.

Fixes: cc53ce53c869 ("Add a dentry op to allow processes to be held during pathwalk transit")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260531-nfsd-testing-v1-2-7bfa481b0540@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ retained the older single-argument follow_down(&path) API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a69287613479b..ec28429c29462 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -130,8 +130,10 @@ nfsd_cross_mnt(struct svc_rqst *rqstp, struct dentry **dpp,
 	int err = 0;
 
 	err = follow_down(&path);
-	if (err < 0)
+	if (err < 0) {
+		path_put(&path);
 		goto out;
+	}
 	if (path.mnt == exp->ex_path.mnt && path.dentry == dentry &&
 	    nfsd_mountpoint(dentry, exp) == 2) {
 		/* This is only a mountpoint in some other namespace */
-- 
2.53.0



