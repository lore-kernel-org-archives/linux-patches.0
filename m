Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057975;
	b=uEM3x3b1ip2ZsgCilSMZ9o4xZMaPz6pkjVVPPLlMRY8mcgO5mDiaqn16rXM7+2w4b4Be
	 xY0wsIEXfXGclv2+hoc8usqmpmSvdcPWkA6jpye+GPSx6IMySs68koOyh6dngwFfel/uv
	 zUOUUMVSImJd9VnFasBrILx7yuMMfjhD2JUOVQxpVfBjx6zOUv9vAnHm2wuCkT2wlBlah
	 /CL9r/eSEuqI349UFcn66pH+76rehYyGohNxosCmQbD2+GF+Jkh+lpxlT3Sv6VdsV5zhN
	 Eg6Mz/D3hgwRMey/NZAq//XtDNhyW4u/7D+EUp/Pj4XpWM7eOou2uXxiY96AptztCYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=00ZeRX8RiWTBPSDDd2l30FZ91JjOdb8XgF7E35LFHmg=;
	b=gB4tB9epyRaCLlz4/6BzD0yzMGS7LXUpV0hOJex06jQK/3BTSXSROQqOyXywYwUYVfEw
	 DWQeCveHRfKC3LfncNyAXfHVuWYxXg8pIoM4avMBIvpv2b6HjjeupZDu2iCmZwxVvzSSF
	 HFHnwyRk8fmAnba/ITuGSbGWIvQLzAAylYwhyV6omfhUmAoSGfGjzBCn3hb7p5eeXpMHd
	 VUgGg78ZuPPHDMsT+pBmVe5MDidfuFdzxabktiOE1UongnU85LS9l02WBVcrxbhWRRNuU
	 G1qv9TjtkpjPoyEaBb5/nHyW+2987+zRRUeW8ePn4BeBHT6HtHj06ZKm6athscwB6tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwQNgr1a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879CF606A32A;
	Thu, 19 Nov 2026 03:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AwQNgr1a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81981F000C4;
	Thu, 19 Nov 2026 03:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057975;
	bh=00ZeRX8RiWTBPSDDd2l30FZ91JjOdb8XgF7E35LFHmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwQNgr1a6mHCehjsykJG4/JGS3QWJToJVtPUbvqMlq7CVMZxlTWfov+4mjoh4xUEE
	 XRY06vBTYXpB5PtKbSDx4/VO+QU2IJEiSz10owmJj1ptXbD2wKVBn0tX6TYID3e3VZ
	 E6DL9mcuE6EPa1+ssT78V3lspFghy6HP1QyYeb5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lutomirski <luto@kernel.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 0322/1848] tun: Require CAP_NET_ADMIN to attach to an ownerless device
Date: Wed, 18 Nov 2026 15:39:20 +0100
Message-ID: <20261118145925.639105072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit ffdf678dd16610e3f006dac904bd37c09684673c upstream.

Twenty years ago I made creating a tuntap device require CAP_NET_ADMIN
in commit ca6bb5d7ab22 ("[NET]: Require CAP_NET_ADMIN to create tuntap
devices.")

The idea was to allow the permissions on /dev/net/tun to be relaxed to
0666 and thus allow owners of tun devices assigned with TUNSETOWNER to
actually open it and get at their devices.

What we missed at the time was that persistent devices with *no* owner
were already essentially world-consumable, and anyone who could open
the device node could also attach to those.

Even then, using persistent devices with no explicitly set owner — on
the (false) presumption that CAP_NET_ADMIN would be required to open
them — wasn't an egregious userspace bug. There are cases where it does
make sense to separate the creation/configuration of the netdevice, from
the process which shovels packets into it.

Since then, TUNSETGROUP was added a year later in commit 8c644623fe7e
("[NET]: Allow group ownership of TUN/TAP devices."). Its commit message
noted that if both uid and gid are set, both have to match (in itself a
bizarre choice) — but still not that with *neither* set, no permission
at all was required.

Then in 2012 commit c8d68e6be1c3 ("tuntap: multiqueue support") allowed
new queues to be attached to a device from the moment of its creation,
with no way for userspace to close the race between creation and a
subsequent TUNSET{OWNER,GROUP}.

In 2024, commit 3ca459eaba1bf ("tun: fix group permission check") tried
to fix things to be saner: only require the user *or* the group to
match, in line with standard POSIX permissions, and require
CAP_NET_ADMIN if neither the user nor group authorised the access
(although it put the CAP_NET_ADMIN check first, and would wrongly have
reported the capability as having been used even when it was not).

That fix was reverted in commit a70c7b3cbc06 ("tun: revert fix group
permission check") due to allegedly causing a regression in an selinux
test suite which *expected* the attachment to succeed when authorised
by none of user, group, nor CAP_NET_ADMIN:
https://lore.kernel.org/netdev/CAFqZXNtkCBT4f+PwyVRmQGoT3p1eVa01fCG_aNtpt6dakXncUg@mail.gmail.com/

We should not break UAPI. But we don't have to consider an selinux test
case which deliberately exercises a security flaw to be UAPI worth
preserving either. To which end, I have fixed it in selinux-testsuite
commit b2f894f0016b ("tests/tun_tap: set an owner on the device for the
relabel tests").

So: fix the lack of CAP_NET_ADMIN check on devices which *haven't* been
assigned an owner or group, while leaving the weird tun ownership model
as it was (user *and* group have to match, if both are set). If someone
still wants to fix the latter (which wasn't actually the reason the
previous attempt was reverted), they can do it under separate cover.

Permit attaching to an existing device only if an owner and/or group was
set and the caller matches all that were set, or if the caller has
CAP_NET_ADMIN. The only behavioural change is that a device with no
owner or group now requires CAP_NET_ADMIN to attach — precisely the
loophole we want to close.

And put the CAP_NET_ADMIN check in the right place this time.

Fixes: ca6bb5d7ab22 ("[NET]: Require CAP_NET_ADMIN to create tuntap devices.")
Reported-by: Andrew Lutomirski <luto@kernel.org>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/3c77f88acff5b3c2617b22d64faad15f6212619c.camel@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -586,14 +586,18 @@ static u16 tun_select_queue(struct net_d
 	return ret;
 }
 
-static inline bool tun_not_capable(struct tun_struct *tun)
+static inline bool tun_permitted(struct tun_struct *tun)
 {
 	const struct cred *cred = current_cred();
 	struct net *net = dev_net(tun->dev);
 
-	return ((uid_valid(tun->owner) && !uid_eq(cred->euid, tun->owner)) ||
-		(gid_valid(tun->group) && !in_egroup_p(tun->group))) &&
-		!ns_capable(net->user_ns, CAP_NET_ADMIN);
+	/* If both uid and gid are set, *both* must match */
+	if ((uid_valid(tun->owner) || gid_valid(tun->group)) &&
+	    (!uid_valid(tun->owner) || uid_eq(cred->euid, tun->owner)) &&
+	    (!gid_valid(tun->group) || in_egroup_p(tun->group)))
+		return true;
+
+	return ns_capable(net->user_ns, CAP_NET_ADMIN);
 }
 
 static void tun_set_real_num_queues(struct tun_struct *tun)
@@ -2786,7 +2790,7 @@ static int tun_set_iff(struct net *net,
 		    !!(tun->flags & IFF_MULTI_QUEUE))
 			return -EINVAL;
 
-		if (tun_not_capable(tun))
+		if (!tun_permitted(tun))
 			return -EPERM;
 		err = security_tun_dev_open(tun->security);
 		if (err < 0)


