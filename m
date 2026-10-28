Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209217;
	b=GEVp2BunqEj/urBJbn/E9TbTToDNutPGkonwzgpT279l8sUXLzdSrTAgpsqvHfDo9FPu
	 T60fI+X4PQ5VxQUsAsQOZRlcsssX6I7iNUHo23ECnyCKAsn6TorP1B1uhm7IzYVHl7kSd
	 +a4Z5IpbAATg3neOM7IUOqEb//vx1Nb7+g+9mt/bjMpzH9Z1L5JoexRq5HcxMpTmG4eQq
	 RUYi46DAoYRJZBHiz1Jm/i0XD4XtIx7X6XhgpJIkHuBpd8eAGwmhQDr5sNytbFcdJuLlt
	 zIr6sxnegASkFgzEpB7lMaU7AKbzKI7hyrpovs720C0TacXJuP0TYNFm7tcmjztE7cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ix3b/pA5NdHpprYtKIqMWkwJZE0IU+3LYBIFTcxgNU=;
	b=gsx/qeSA+Z84o8x6I75+uJFwLZTHNOQB2PsnjgGNuG8NTOCyonm12BvK2CfuWtdqOxT9
	 AOld+CNibrL2DPxDvMXD2/xEYceU5jdEY/qm1lnK/Ly/xUcQpX6KsrsZJ1uwZYvXLxG3b
	 SJeY4zqwXJ2COvQylwbn046L8bhA3heqJoaiQwjWCL/s87gS8oFT33NDDVF9qdKuRJSD4
	 rPArguCMtb8pkuEt6NkFOYXwT1NjggFC+cqSZ0Gxea/jbC+F8eag6CCx6aeAQ16s+2YKC
	 LzD2nAAtSJAYOHh+XVjnBnY8B60fdTUESCI2mwnbZRAyJOAbitroyaDydrXeSW9TmWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ojqR1Lc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49924606A31C;
	Wed, 28 Oct 2026 17:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ojqR1Lc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF4E1F01825;
	Wed, 28 Oct 2026 17:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209215;
	bh=0ix3b/pA5NdHpprYtKIqMWkwJZE0IU+3LYBIFTcxgNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ojqR1LcJFUtSgVvCMzP4wBmBpJAlgY7GN+ZzQRB70j6gGFL7XVKc+C3tcHKak998
	 0ZTHCekhNNNxjX6JtPNSIjvGc/kMsjGRtjyyquhOOGIuqKCqPRhjfatQdl0Ah1vbKU
	 oAFvNcWFgmGgIUa9Ta28Torovdmxib1sNOOtq42k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 393/516] scsi: ch: Do not keep references to data transfer element devices
Date: Wed, 28 Oct 2026 17:59:05 +0100
Message-ID: <20261028170012.790752685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>

[ Upstream commit 27c0f718d3b3c99e6d315308e95d987d0382a8a8 ]

ch_readconfig() looks up the scsi_device of every data transfer element
whose SCSI id the changer reports in READ ELEMENT STATUS, and stores it in
ch->dt[]. scsi_device_lookup() takes a reference, and nothing ever drops
it: ch_destroy() frees the array with kfree(). ch->dt[] is read nowhere
else - it only supplies the vendor, model and revision printed in the same
loop.

Once such a drive is removed, its scsi_device can never be released. It
stays on the host's device list at its address, so a new device there is
refused by anything that walks the list - target_core_pscsi reports
"scsi_device_get() failed for H:C:T:L" - and the low-level driver's module
can no longer be unloaded. Only a reboot recovers.

It shows with any changer that reports its drives' ids; with the mhvtl
virtual library (IBM 3573-TL personality), each create and remove of a
library with four drives leaves four references behind, counted by the
module's use count in lsmod. With ch not bound the count is unchanged, and
with this patch applied it is unchanged too.

Drop the reference as soon as the name has been printed, and remove the now
unused dt[] array. That also removes the array leaked when ch_probe() fails
after ch_readconfig().

The same leak was reported with an RFC patch in 2022, which was not merged.

Fixes: daa6eda65a53 ("[SCSI] add scsi changer driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-scsi/20220719075442.6215-1-yanghao_ht@163.com/
Signed-off-by: Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Fixes: daa6eda65a53 ("[SCSI] add scsi changer driver")
Link: https://patch.msgid.link/20260929-ch-dt-leak-v2-1-ddda8d635dca@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ sashal: adapted removal of kzalloc_objs() to the existing kcalloc() allocation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ch.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index cb74ab1ae5a4d..cf44ab033112b 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -110,7 +110,6 @@ typedef struct {
 	int                 minor;
 	char                name[8];
 	struct scsi_device  *device;
-	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
 	u_int               unit_attention;
@@ -356,16 +355,10 @@ ch_readconfig(scsi_changer *ch)
 			vendor_labels[i]);
 	}
 
-	/* look up the devices of the data transfer elements */
-	ch->dt = kcalloc(ch->counts[CHET_DT], sizeof(*ch->dt),
-			 GFP_KERNEL);
-
-	if (!ch->dt) {
-		kfree(buffer);
-		return -ENOMEM;
-	}
-
+	/* report the devices of the data transfer elements */
 	for (elem = 0; elem < ch->counts[CHET_DT]; elem++) {
+		struct scsi_device *sdev;
+
 		id  = -1;
 		lun = 0;
 		if (elem < CH_DT_MAX  &&  -1 != dt_id[elem]) {
@@ -381,10 +374,8 @@ ch_readconfig(scsi_changer *ch)
 			VPRINTK(KERN_INFO, "dt 0x%x: ",elem+ch->firsts[CHET_DT]);
 			if (data[6] & 0x80) {
 				VPRINTK(KERN_CONT, "not this SCSI bus\n");
-				ch->dt[elem] = NULL;
 			} else if (0 == (data[6] & 0x30)) {
 				VPRINTK(KERN_CONT, "ID/LUN unknown\n");
-				ch->dt[elem] = NULL;
 			} else {
 				id  = ch->device->id;
 				lun = 0;
@@ -394,18 +385,16 @@ ch_readconfig(scsi_changer *ch)
 		}
 		if (-1 != id) {
 			VPRINTK(KERN_CONT, "ID %i, LUN %i, ",id,lun);
-			ch->dt[elem] =
-				scsi_device_lookup(ch->device->host,
-						   ch->device->channel,
-						   id,lun);
-			if (!ch->dt[elem]) {
+			sdev = scsi_device_lookup(ch->device->host,
+						  ch->device->channel,
+						  id, lun);
+			if (!sdev) {
 				/* should not happen */
 				VPRINTK(KERN_CONT, "Huh? device not found!\n");
 			} else {
 				VPRINTK(KERN_CONT, "name: %8.8s %16.16s %4.4s\n",
-					ch->dt[elem]->vendor,
-					ch->dt[elem]->model,
-					ch->dt[elem]->rev);
+					sdev->vendor, sdev->model, sdev->rev);
+				scsi_device_put(sdev);
 			}
 		}
 	}
@@ -569,7 +558,6 @@ static void ch_destroy(struct kref *ref)
 	scsi_changer *ch = container_of(ref, scsi_changer, ref);
 
 	ch->device = NULL;
-	kfree(ch->dt);
 	kfree(ch);
 }
 
-- 
2.53.0



