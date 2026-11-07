Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060721;
	b=WPkhY9A1FaCbG/AqKwBietdImWsDbFikxpCatgCnFTPER4HTPUI6NDHxN3gh/Cg1I4L3
	 wUcLaEW3C3J6baVzwtewhBiP4v+jqXvtv2U06gEytqZRTnU3q+DYkIna0foq3z67nKoXx
	 01TUDqVz2wPB9F1KRrfn9SgHFxH7vwQ1s7VEOWhLGye3eN2yXykOyiEjgfWWgK3A1hwWb
	 W/ktoPWVJkbiezzIRn+xVSFREnBdAq4XBLKdwZiny6mUt9lS8RI8cA6FtzEmK1i5dB8V0
	 0cpB4rDEjqAfpLYSPR9JLOL0b6ZI5GrZyLjtje1OPnAL64r1SjARh28K4j/vGTcGEJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JPTByGW1F0XyU88RociSSR/gJqnBA0TzKo3BONDgKW8=;
	b=K4Mtb52Rxg7n9UDvVlZDE4TMJxYx3M4fJXTk8ZsMNNHZw9Xt2yFMyWSkilgG+dDfkQJt
	 MWlRmXM/c/B5Pu0gVIttxxAGCMzeUKbmTmd1iiYi6DGtOKgGb+f1lf74wCfD8H3DgYSCm
	 7kS18bxXvdqb2RQhRGmiY11BEb5dEC0mjQjZI7BxjdeSsEw2R/1L2GUvZnZkigW9cWVZ4
	 gGqHIPGvuIYZFKuU4XR6UObLKti8cWOAE4FnYvl4kfuQtWAhVe3ow+ehRIS1KZlEQhemL
	 sZ4y7ziylVFqGBnemyf1Z0LLXYdcBOviI71KcI+dUtivHY+qCA/M7/pDfJvG0ELBwcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FkW+GrdB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F50606A326;
	Sat,  7 Nov 2026 14:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FkW+GrdB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690201F0089F;
	Sat,  7 Nov 2026 14:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060720;
	bh=JPTByGW1F0XyU88RociSSR/gJqnBA0TzKo3BONDgKW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FkW+GrdBOxMYOPDQ3SGx7q6Qk9mD7QEsZ5uaV/4zeFQKDwA5GpQQ1xKpn52BiFBqi
	 d8yRs6qb54fNGRjeXvoJvTm+BrwpJ8H8E2hkP6XCo05byfB4e+V7RSIcQk41UtyrtZ
	 mgQKwd+O/9r0QTH5Bf8KC1HmHWyRvC02PULUQ4kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com,
	Michail Tatas <michail.tatas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0142/1536] USB: misc: uss720: Fix leak in get_1284_register
Date: Sat,  7 Nov 2026 08:35:58 -0500
Message-ID: <20261107135001.680008902@linuxfoundation.org>
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

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 15902712b9e2a46649cba2f22002d05faec2a990 ]

if wait_for_completion_timeout() times out in get_1284_register()
then we do not destroy the reference acquired via kref_get() in
submit_async_request. Add the missing kref_put in the timeout path.

link: https://syzkaller.appspot.com/bug?extid=56962eb32ba0136cd330

Reported-by: syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com
Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Link: https://patch.msgid.link/allaDTUua9n5DQ0a@michalis-linux
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/uss720.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 6ebcfaf525989..a405a36d8d42f 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -223,6 +223,7 @@ static int get_1284_register(struct parport *pp, unsigned char reg, unsigned cha
 	}
 	printk(KERN_WARNING "get_1284_register timeout\n");
 	kill_all_async_requests_priv(priv);
+	kref_put(&rq->ref_count, destroy_async);
 	return -EIO;
 }
 
-- 
2.53.0



