Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211342;
	b=I4ZTKMiwa1sND7U6jyyRkyUgXjo0euRkxAXsRPR/DQ5NpigqJNjHll2jaXpaHmfyMl4O
	 wJokrUKE+RZ7O/m5p4SP8LB/Uwv3Qef8VSTNHkAEEkYVqiPdcM5YdPxvO5N5NFD1lRfEb
	 aQ3QxcAxv+jxrUJ9JN86rSjGUpXLFKAa5pDwr2B2GbJGwUH/b9eZ4i2iem9J508rew8al
	 PGmWFWRHzf6Q/EQj0MWP0mnkpUOmhqXJii6RKtTAi1wuxEuFUOxcIExji3Q+CV5/sUhkb
	 XkHdSZN4qdGCK7CG9z8M5MqC6DPIFKdeb29+wLa+lM3wRXtguDvVlqfmgY4fhU0XgFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sezW3KiwMTOsU0OigU9PJVT8QQ7f6hS5Q6ICaoMMmG8=;
	b=MyN6LSFJ2alPMn5OCTQuzh7FeXYMLpd135PhqHCEyY0Zyqqn7pzoeQQWYw/ujHNC0Kyw
	 DXh54uAp94LOab/HdOnLvI8q6AAlcor2GEJd1TU/Umld8TGplqZ2IAf6nV8kS1pu2YtX3
	 4Y9bXa0kpNQLKiYwZWTXNcbnNRyq7yr8XglLMJK5hjlDwSVhSjaCPjyz9u2fCDo6+K7Fb
	 46wjgQDsxHo+bEyydkW5+Uz3bMbGBz15t9D+KoxHQygBQTalMM8TQOt2k8iM+wmiTZTHX
	 gvcNB7O3VcFqoKfdOGAZ537gsRMUVgvaguyRwgaVJk9bQ0n+mDSJaqe0EvcJ3bjFRWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6RmH+YW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34970606A95C;
	Wed, 28 Oct 2026 18:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6RmH+YW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856F01F01825;
	Wed, 28 Oct 2026 18:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211342;
	bh=sezW3KiwMTOsU0OigU9PJVT8QQ7f6hS5Q6ICaoMMmG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6RmH+YWv5w+LtA2SePV0kg2juivjDqEvKIKlPjIV8xcrejiuvovXR+7bvO6Srq2W
	 JAXpEkK3QPcgXK2RShp1BtMlMVDOkclnzC9S264NUJEZA7Nex7U2VA9kMX7lh9WSQT
	 kiIJDyiuTJwA3DjPzg/u7KbH8CAHsHkyGLNvLtYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 344/571] ipv4: stop route notification sizing when nexthop group shrinks
Date: Wed, 28 Oct 2026 17:58:11 +0100
Message-ID: <20261028170016.180164808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit d3daa33c7af92e38f2274bbd2576f58bfbaf89e6 upstream.

Commit 680aea08e78c ("net: ipv4: Emit notification when fib
hardware flags are changed") added an RCU-only fib_nlmsg_size() call
for asynchronous hardware flag notifications.

fib_nlmsg_size() checks fib_info_num_path() before each iteration,
then fib_info_nhc() independently reloads nh->nh_grp. If
RTM_NEWNEXTHOP replaces a group with fewer paths between those loads,
fib_info_nhc() returns NULL and fib_nexthop_nlmsg_size() dereferences
it.

Stop sizing when the indexed path is absent. Nexthop groups are
dense, so the current snapshot has no later path.

Fixes: 680aea08e78c ("net: ipv4: Emit notification when fib hardware flags are changed")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/1054fa46165bba1b473782fa41367804aa908e86.1790915964.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -512,6 +512,9 @@ size_t fib_nlmsg_size(struct fib_info *f
 			struct fib_nh_common *nhc = fib_info_nhc(fi, i);
 			size_t nhsize;
 
+			if (!nhc)
+				break;
+
 			nhsize = fib_nexthop_nlmsg_size(nhc, nhs != 1);
 
 			if (nhs != 1)


