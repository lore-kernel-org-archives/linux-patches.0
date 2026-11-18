Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021754;
	b=38HaNkONLCRDE9ZpCQbPGRh/8NjJscfeYR0oHcVVvzDoi7NDXN/FVeFx8s01CCvEIWVp
	 paNZEVql4uifqHsohqBK0L2f/3kjeZcJuH112mrMjKm4aPuWnJHvqnXFhRVUF6nmFZ8RV
	 LTFVU5PdyYO3k20VHMj3+NTs5nSZ7stU/9cDvx3Nxg10d+gEZMJU1GSODSuxyn37wqQq6
	 56voN6u+F0+4LP04p5XnVJeXUGeK3qLnBJKhWiqCTF76lvt5ALyP0c1sIFRtR4k00UKEr
	 99C3aiDF+cP57a0K0AjXs0rM9NEZtqrJmpUeGOLRv4gxHtD1n4k4KM7wo3Z5tAo7ykA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EWKIH4C0NchJNgdsC5Q6TRtTwlQuUk0mtvtYcbl/pSY=;
	b=wm+CC88qi10aTAv4emamOAFaE8MYb/8y6B+nc2OOrNxGEaGCzHk7trKXmltBq0R8zaBt
	 6NoEbzH8c4bXYLyxakE9DoGQVcFT/5AY+wNDRnNWwh4dxtLKAg5bdbVYhw9ccEAc5DgJm
	 SHHfW9WC4faxUv+E79nPSwaSkspRzvMBjukc9u5qR9e8c9w+tSt0r9CHEKMhS9LsuiKB7
	 R+gAgcDWrnAmvoJiZ+uPbz7+FK6WLng9ArThi8Jjrg+RW4PTTnKjW4636epfq7b9cDqRY
	 aBf4CMkbYjZ0VVQycKDNVzl1Foa2NgpVICZrIShymvjhT6AT/1GaXt0UY+uajMGLkGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4wMglnC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B455960A2600;
	Wed, 18 Nov 2026 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4wMglnC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01031F000C7;
	Wed, 18 Nov 2026 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021754;
	bh=EWKIH4C0NchJNgdsC5Q6TRtTwlQuUk0mtvtYcbl/pSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4wMglnCQog70dNwLxvWdZzDt+yDY9CTwzN9oMAogJ+EDI87poH8LkOFcdCcPVT5k
	 DbgCxlXkXg1qWWc/nBm3Mk7NoXui0mr9jYnSeGd84frguM1oLxzIRgjjgus4tIoW5a
	 aXE4L6xLdCLz13L7oQovY7LAIRTUq3a7GH5a454c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2420/2651] ceph: dont keep a mon_addr string that failed to parse
Date: Wed, 18 Nov 2026 16:01:00 +0100
Message-ID: <20261118150412.376858816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 6c82bff8561f4c20dc0113f81cb2f6e6e2b4cf70 ]

ceph_parse_mon_addr() stores the string in fsopt->mon_addr before handing
it to ceph_parse_mon_ips(), and then returns that function's error. So
after a mon_addr= that does not parse, fsconfig() reports the failure but
the mount context keeps the rejected string.

That matters because ceph_get_tree() uses fsopt->mon_addr as the "monitor
addresses were supplied" test:

	if (fsopt->new_dev_syntax && !fsopt->mon_addr)
		return invalfc(fc, "No monitor address");

Userspace is free to ignore the error from fsconfig(FSCONFIG_SET_STRING)
and go straight to FSCONFIG_CMD_CREATE. The check then passes on a value
that was rejected, and the mount continues with ceph_options::num_mon
still 0 - which is how syzbot reached the BUG_ON() in pick_new_mon()
fixed by the previous patch.

Parse first and commit only on success. A failed mon_addr= now leaves any
previously accepted value in place instead of replacing it with one that
does not parse.

Fixes: 7b19b4db5add ("ceph: new device mount syntax")
Reported-by: syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1dbed5969931c19d3eb5
Assisted-by: Cursor
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 4306d6b3b995f..416bf86996a03 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -394,13 +394,18 @@ static int ceph_parse_mon_addr(struct fs_parameter *param,
 {
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct ceph_mount_options *fsopt = pctx->opts;
+	int ret;
+
+	ret = ceph_parse_mon_ips(param->string, strlen(param->string),
+				 pctx->copts, fc->log.log, '/');
+	if (ret)
+		return ret;
 
 	kfree(fsopt->mon_addr);
 	fsopt->mon_addr = param->string;
 	param->string = NULL;
 
-	return ceph_parse_mon_ips(fsopt->mon_addr, strlen(fsopt->mon_addr),
-				  pctx->copts, fc->log.log, '/');
+	return 0;
 }
 
 static int ceph_parse_mount_param(struct fs_context *fc,
-- 
2.53.0



