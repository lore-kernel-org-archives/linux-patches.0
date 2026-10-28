Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214468;
	b=SX0yVMYDE7pcvP5sdxB4SpheE9/zuvuY2X4GGHpjiTU4EzMqnrh1Dlm6oCLjQHaHpxet
	 Tsdh38SBj7rnwq7ADYXClW24No0SfSQIeu+7TwkuRNDAc+jwSS6LRzI9odiFIFrrf4kdu
	 O6HbveVDSN/KiVi9SMFFo0uByz89s6dSVkA/tymZG87L3HzmJ1vDL8QTJVLFZlFib6kts
	 LIt5zGl32PRVafK9NUbetWf9re6GFyUuXiLWyaZh3eB9plQtxXZI6DzM1jvXMsu6sQYVS
	 zBrdukXB/NEIAOHX86Bm8rCmXVsnkDpj+UBNnZU0/XMvTRFNgwbeXRyUtohw8PDNWTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q9PVHKkJ7Wtcrvk3Z7aO+Dhh3JPvJny2PbKYNfvY3eU=;
	b=vaLJAIthu81bpR1BKITLbFGPmx3oWHV1ShFZIKEACzicBiz2GqguA2IJB3UBsiddLq8U
	 hGSdImCJrZwNaZXJlstn58sowlv4nORMP/2/VBXp0upHynU0qpAj/C/UbXOd8fptYAYBW
	 d2MXs6G6mDVOaY0Eix1nnKoE6H0nERxPDDLr8HkohYsm8EYSJVnSdypRsYh9cqo+SAP0D
	 TvPmFKE41S+vvTYmO6ZlzDrLgOmSz8tMRwDaBozPtqKTwfOGVqNQyuVag8bEescfZEhHA
	 gMPE9jgnnD4yswBW72Jvig5uU0TYZcLZ2odRqM+NM2lEN2szNwMc1FGWWth3i7OdBxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvYaz5WE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2986606AB18;
	Wed, 28 Oct 2026 19:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvYaz5WE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053701F031E3;
	Wed, 28 Oct 2026 19:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214467;
	bh=Q9PVHKkJ7Wtcrvk3Z7aO+Dhh3JPvJny2PbKYNfvY3eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvYaz5WEOEVt/tsA6jBPMVUFkBvVarzcqzG+1nat25ZNTFwE+Kj3bw0FEAdzfMe3R
	 vTcE90JydCwj0H7DKmdWB/UQpnFXR3fE04h6R3wjEGY3PGTRJnb0v7ieDIiXfGQltg
	 5s3/wM5ITVw26WiSqEHZ9PIwktuuKDo/L2unwNKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0870/1887] xen/events: Return -EEXIST for bound VIRQs
Date: Wed, 28 Oct 2026 17:49:26 +0100
Message-ID: <20261028170519.216574436@linuxfoundation.org>
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

From: Jason Andryuk <jason.andryuk@amd.com>

[ Upstream commit 07ce121d93a5e5fb2440a24da3dbf408fcee978e ]

Change find_virq() to return -EEXIST when a VIRQ is bound to a
different CPU than the one passed in.  With that, remove the BUG_ON()
from bind_virq_to_irq() to propogate the error upwards.

Some VIRQs are per-cpu, but others are per-domain or global.  Those must
be bound to CPU0 and can then migrate elsewhere.  The lookup for
per-domain and global will probably fail when migrated off CPU 0,
especially when the current CPU is tracked.  This now returns -EEXIST
instead of BUG_ON().

A second call to bind a per-domain or global VIRQ is not expected, but
make it non-fatal to avoid trying to look up the irq, since we don't
know which per_cpu(virq_to_irq) it will be in.

Cc: stable@vger.kernel.org
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250828003604.8949-3-jason.andryuk@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 0a468c2f9895e..bdfbe27591593 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1324,10 +1324,12 @@ int bind_interdomain_evtchn_to_irq_lateeoi(struct xenbus_device *dev,
 }
 EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irq_lateeoi);
 
-static int find_virq(unsigned int virq, unsigned int cpu, evtchn_port_t *evtchn)
+static int find_virq(unsigned int virq, unsigned int cpu, evtchn_port_t *evtchn,
+		     bool percpu)
 {
 	struct evtchn_status status;
 	evtchn_port_t port;
+	bool exists = false;
 
 	memset(&status, 0, sizeof(status));
 	for (port = 0; port < xen_evtchn_max_channels(); port++) {
@@ -1340,12 +1342,16 @@ static int find_virq(unsigned int virq, unsigned int cpu, evtchn_port_t *evtchn)
 			continue;
 		if (status.status != EVTCHNSTAT_virq)
 			continue;
-		if (status.u.virq == virq && status.vcpu == xen_vcpu_nr(cpu)) {
+		if (status.u.virq != virq)
+			continue;
+		if (status.vcpu == xen_vcpu_nr(cpu)) {
 			*evtchn = port;
 			return 0;
+		} else if (!percpu) {
+			exists = true;
 		}
 	}
-	return -ENOENT;
+	return exists ? -EEXIST : -ENOENT;
 }
 
 /**
@@ -1392,8 +1398,11 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu, bool percpu)
 			evtchn = bind_virq.port;
 		else {
 			if (ret == -EEXIST)
-				ret = find_virq(virq, cpu, &evtchn);
-			BUG_ON(ret < 0);
+				ret = find_virq(virq, cpu, &evtchn, percpu);
+			if (ret) {
+				__unbind_from_irq(info, info->irq);
+				goto out;
+			}
 		}
 
 		ret = xen_irq_info_virq_setup(info, cpu, evtchn, virq);
-- 
2.53.0



