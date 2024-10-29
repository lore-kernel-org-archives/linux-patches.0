Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3D7204032
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 10:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730197104; cv=none; b=R9aMkFI/MOjh/fshiAlq5L5NXdleoEMw9NDvZMr25r4g+nzNqZm59Zi2/G+LsV798OE6/XPdwhV9xIeTpB6rol3w8E+NndGAgqizD7MZBvpBkJKhMpmSPkYCq9hWY6X3bQqq3X626ASyw+xy5BtNk+GzVl7wdOFeBJskrWdevik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730197104; c=relaxed/simple;
	bh=chy4K3lAqu9T3cNWx7PQ01IEpmqlKtiZaveYDTJB5Wc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQTqP6dGv7Xm2t042fp+MkTiuSK0syUg9deVrJ3H2iGI0zow5lQ5ZmCl2tpVRE+Fh/ZpghJbRZqYEcwE9JpVwl22coEoAWdiwDirD365/dN+YnUpJxmi0J3hcrc10uNgV7RHXYnPI9MqgZFrjqNLutJXlqD/MzqO9wJBnmW7Fp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=mgqKvZeI; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="mgqKvZeI"
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 48F6320872;
	Tue, 29 Oct 2024 11:18:17 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HqVcEP6qFQOD; Tue, 29 Oct 2024 11:18:16 +0100 (CET)
Received: from cas-essen-02.secunet.de (rl2.secunet.de [10.53.40.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id F0AEB20891;
	Tue, 29 Oct 2024 11:18:15 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com F0AEB20891
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1730197096;
	bh=fQrW1pDY7CtPwXrG2SJfo8HyNFzWqBd0Ybbdidl1pQA=;
	h=Date:From:To:CC:Subject:Reply-To:References:In-Reply-To:From;
	b=mgqKvZeIj3Zjqptb/vh7BSDuMrenukgHcwMjloLYj+HOMzb/oYaG4twU4mooSYWn4
	 mfeW45/eiQk7rb9zwNGyPUBBXJBFIY9kjtXpdka4FwWfDrXzK7kPg2tCALZfs1m/dE
	 1CWem7iHoSU38XtbjizIAARcK8geriVCpjQ4qB7I2Obz1qd1AKqqMfHfWoE9nE08GH
	 y2dgKgw8ZJB2+ijkfEYSgtqc/UHS6WEpBtsJ8waKkZ40Jc+rp60RzLiTz4RiXfK/Dp
	 FlVCkf8n6sKItGUdBoIwC9wRGbT0+/vceuq1Wi7tc2Dr1YJojIFcYlJzEAqCToSQ+/
	 chOq84QPDnyxg==
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Oct 2024 11:18:15 +0100
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 29 Oct
 2024 11:18:15 +0100
Date: Tue, 29 Oct 2024 11:18:04 +0100
From: Antony Antony <antony.antony@secunet.com>
To: Sasha Levin <sashal@kernel.org>
CC: Antony Antony <antony.antony@secunet.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, Sabrina Dubroca <sd@queasysnail.net>, "Steffen
 Klassert" <steffen.klassert@secunet.com>
Subject: Re: [PATCH 6.6 133/208] xfrm: Add Direction to the SA in or out
Message-ID: <ZyC2Ow9usJkkpxjU@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20241028062306.649733554@linuxfoundation.org>
 <20241028062309.914261564@linuxfoundation.org>
 <Zx9wp6atLMR1UcCL@moon.secunet.de>
 <Zx-Gp8f9jjxmDsIe@sashalap>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kEvXCRMXLtCk+Dwf"
Content-Disposition: inline
In-Reply-To: <Zx-Gp8f9jjxmDsIe@sashalap>
Precedence: first-class
Priority: normal
Organization: secunet
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

--kEvXCRMXLtCk+Dwf
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Oct 28, 2024 at 08:42:15 -0400, Sasha Levin wrote:
> On Mon, Oct 28, 2024 at 12:08:23PM +0100, Antony Antony wrote:
> > On Mon, Oct 28, 2024 at 07:25:13 +0100, Greg Kroah-Hartman wrote:
> > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > Hi Greg,
> > 
> > This patch is a part of a new feature SA direction and it appears the auto
> > patch selector picked one patch out of patch set?
> > I think this patch alone should not be applied to older stable kernel.
> 
> It was picked up as a dependency:

I understand how it got selected, however, please drop
a4a87fa4e96c ("xfrm: Add Direction to the SA in or out") from backports.

> 
> > > Stable-dep-of: 3f0ab59e6537 ("xfrm: validate new SA's prefixlen using SA family when sel.family is unset")

this is good fix to have in stable kernels

> 
> We can drop it, and the netfilter folks can provide us a backport of the
> fix above?

It is an ipsec sub system patch.
Here is a backport. I compile tested it on 6.6. It will also apply to linx-6.1.y
To apply to older ones kernels, use -3. 


regards,
-antony

--kEvXCRMXLtCk+Dwf
Content-Type: text/x-diff; charset="us-ascii"
Content-Disposition: attachment;
	filename="0001-xfrm-validate-new-SA-s-prefixlen-using-SA-family-whe.patch"

From 728db0e41ea88d26198c14c383489c6f8509edee Mon Sep 17 00:00:00 2001
From: Sabrina Dubroca <sd@queasysnail.net>
Date: Tue, 1 Oct 2024 18:48:14 +0200
Subject: [PATCH] xfrm: validate new SA's prefixlen using SA family when
 sel.family is unset

[ Upstream commit 3f0ab59e6537c6a8f9e1b355b48f9c05a76e8563 ]

This expands the validation introduced in commit 07bf7908950a ("xfrm:
Validate address prefix lengths in the xfrm selector.")

syzbot created an SA with
    usersa.sel.family = AF_UNSPEC
    usersa.sel.prefixlen_s = 128
    usersa.family = AF_INET

Because of the AF_UNSPEC selector, verify_newsa_info doesn't put
limits on prefixlen_{s,d}. But then copy_from_user_state sets
x->sel.family to usersa.family (AF_INET). Do the same conversion in
verify_newsa_info before validating prefixlen_{s,d}, since that's how
prefixlen is going to be used later on.

Reported-by: syzbot+cc39f136925517aed571@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_user.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 979f23cded40..b8f8d3066eb4 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -176,6 +176,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 			     struct netlink_ext_ack *extack)
 {
 	int err;
+	u16 family = p->sel.family;
 
 	err = -EINVAL;
 	switch (p->family) {
@@ -196,7 +197,10 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	}
 
-	switch (p->sel.family) {
+	if (!family && !(p->flags & XFRM_STATE_AF_UNSPEC))
+		family = p->family;
+
+	switch (family) {
 	case AF_UNSPEC:
 		break;
 
-- 
2.30.2


--kEvXCRMXLtCk+Dwf--
