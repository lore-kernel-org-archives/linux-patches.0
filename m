Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028017;
	b=Lvz3duffCA78azChvJunqADV2S+RFgHAG7Ac18mwTeAPXXcdVFifrl9onLIjzhURgobl
	 SVtrkVkVJbUHRse2OMhiblaw2M8xJ3v7EcyjswKLgfhIACm2/UF6LTTdChmypyHSso/xM
	 KVqsRnscyA6c8g9MX3bvRTfZfL7w/xd5x6kmx9B5ZDCkkIH1fS7nGqo1Mmfm2Pr0WFAdr
	 +151XjI+jJD2Uz8Chdqsg5cMziqX/ywpoSZGLQSaB9ZRAID4MiLdZgaSVON1TmlzyPh1Q
	 djRoStErT+raRBQnR9ZvvdNmVWWnpkS2JtTP31wBPJySJp4IINXXwtqhAbvi0e/YEdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4pmSIAOxfwweAqOstxFcPpWkaj9ue3XJu+Usau+wq0o=;
	b=n0zupEJADObUeElzJndRFkZTYeVHfMhXcTa0ji6t1QwLdYimwIJO8yX6vzEd4Pn4mwLK
	 3ULt1KHcnB2MpYzXGjU6NZlllMkwJUncnTGAjFBTQ+d4ksKDP4wrwqrM910YOxG9vn4Bp
	 552tkbeK6e9RFk/z1SKejqK8+YpS7OqmgnyfnQ2/+qXD7gLIQSjxnciV9E3vbdmg/l7u0
	 eLMoN6DhKvXblyds2XTmZPNTOCWrPsbNsWrYLuFs7PcQxic/wu2oOp84SJzPzMLwahj30
	 ooB3lwu3gPmEc5rHsyvZvuLrps1Hp4pciNIwxiq137KgtsXlBlmnoPP0p+BkE8mGOrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OFixMtU+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2508C606A31C;
	Wed, 18 Nov 2026 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OFixMtU+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746F81F000C4;
	Wed, 18 Nov 2026 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028017;
	bh=4pmSIAOxfwweAqOstxFcPpWkaj9ue3XJu+Usau+wq0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFixMtU++dhFTB3Q32cxzhwAa/W8kg3nrbQXwLLSQtPV7ghoSYD/hjkroWu0FRvTn
	 Z0C3m1Q8zfFmdqnnipUcKqbwUp6m2OK2tgBsz2Vauq+Z/UHBGl407DpWbae3jly1uU
	 kSI1gI8vEcxHA4QpZzx+qRq3MAOhTEipcZ8ZA68A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1958/2151] ceph: dont keep a mon_addr string that failed to parse
Date: Wed, 18 Nov 2026 16:01:33 +0100
Message-ID: <20261118150233.086715166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 4ca777f30a48e..25e32c717a406 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -388,13 +388,18 @@ static int ceph_parse_mon_addr(struct fs_parameter *param,
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



