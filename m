Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051604;
	b=LfrUyyEiJ6keoHdrj22YLgCrZqIUgMiA09xqY4/326+dH1zo9vZpRk9N6plpQCIPNoKL
	 BWhsCee4SrECXOqsEn5QFEsi4XD5fGksvtbuCO7B4nG2+BWJCMI8S725CnidDUPklNZo8
	 ISp3/rASx9gyH1hawIzl0QZl0LKIDh8/JJ+xpJwuo5+240DAcmc+55RGnsknwDMDcl/4F
	 c7t5DsKObL2EL6JANBo7ccAGLmBJAPOuyZhRhgNf3km1BlyGX61Tyd08Js2ZZsTafI3uo
	 87ZGeGjnp3+VAxpdxvRk6D+zDS1PEl/u4waecoOgjcOOp2fSTmpWKbw/Ir0tgiCzI1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5RfwB9YUBnZFyW59CBUyxroy0ji5N/I2Zqfw2gTstOE=;
	b=pRM3VgUW4xVHO7xEGdOh0Cr6S/oVd/HSJsCQ7nAkROmSnZ6Il+dYsokmnRA3SN4ebluo
	 kiEtxnhWJ1O18YXbtpHkpsL+VtVMCQ/4hCK35hc6+8GKs0mk/37D1ynGwPaetFeIk1+Kv
	 XqYSEBe2peQqYy6/cOhDCVMD5A7iaT2YQEI62szn/7fBbef4yri+6ZUvfSrknk8gVMCf5
	 HRfqiqCwQTgMJxLYhkJWSbq/6Wru7KAQDRaQK5Gu24EG6CkzpJ30HAKI0heUhLEgqSPry
	 UwJtol4SP0BMonk97aBMQ7vtE8gZg4l9ITEKGvUH5n6M+6CtLeBzSdQg2rB03eW4lYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPy13ukA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711F5606A320;
	Thu, 19 Nov 2026 01:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPy13ukA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99581F000C4;
	Thu, 19 Nov 2026 01:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051604;
	bh=5RfwB9YUBnZFyW59CBUyxroy0ji5N/I2Zqfw2gTstOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPy13ukAOSG8bf6gyH9VUhkZ+gjzc8wEsafaYRZ93PiNxvj/I2N3h8QalWnHaIFZB
	 f/h2kpmRnGMPNhDrjRQX8mAjRBHoVchHB/mB/AovkO+p3wXHYV2VIcSU3oOoEQwB/Q
	 3jdm2tnQ9VnEQSo5LQvttd0IVpNoE1RvuKjexF2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gopel <jgopel@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 0268/2214] thunderbolt: Do not RPM complete unrelated subtrees on unplug
Date: Wed, 18 Nov 2026 15:32:24 +0100
Message-ID: <20261118150020.806289722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Jonathan Gopel <jgopel@gmail.com>

commit 96a8479804e3f7af43e639e9df39f562f1a75fd5 upstream.

When a Thunderbolt device is unplugged, that switch and every switch
subsequent to it on the bus device list is `complete()`d, not just its
child devices. In the case of multiple domains, it may cause, eg, an
attempt to `complete()` the uninitialized domain 1 root switch RPM
completion on unplug of a switch from domain 0 (though ordering is not
guaranteed numerically sorted).

I initially noticed this issue on a Dell XPS9720 when the system would
seem to sporadically not wake after unplugging a Thunderbolt dock. I
tried multiple kernel versions including v7.2.7 and v7.3-rc4 to see if
that resolved the issue, but the issue persisted. Eventually I found
that I could consistently generate a kernel Oops reporting a page fault
at 0xffff_ffff_ffff_fff8 on unplug from one side of the laptop and went
bug hunting. I became suspicious of the `bus_for_each_dev()` walk that I
ultimately ended up changing. To confirm this issue, I did an eBPF trace
of `bus_for_each_dev()`, `complete_rpm()`, and `complete()` while
unplugging in a variety of situations and found that an unplug from
domain 0 tries to `complete_rpm()` domain 1's switch, whose RPM
completion is not initialized and thus is holding a null wait-list
pointer, triggering the page fault.

Here are the key sections of that eBPF trace. Note that HEAD denotes the
completion's own wait-list HEAD:

```
RESCAN_ENTER domain=0

COMPLETE rescan_domain=0 target=0-1 target_domain=0
         route=0x1 parent=0-0 unplugged=1
COMPLETION done=0 head=HEAD next=HEAD prev=HEAD

BUS_WALK domain=0 start=0-1 callback=complete_rpm
CALLBACK_ENTER rescan_domain=0 dev=1-0 parent=domain1 is_switch=1

COMPLETE rescan_domain=0 target=1-0 target_domain=1
         route=0x0 parent=domain1 unplugged=0
COMPLETION done=0 head=HEAD next=0 prev=0

        complete+5
        complete_rpm+43
        bus_for_each_dev+133
        icm_free_unplugged_children+250
        icm_rescan_work+42
```

This patch gates the `complete()` on an additional condition - that the
Thunderbolt domain matches the domain of the device that was unplugged.

I only have a single system with multiple Thunderbolt domains - the Dell
XPS9720. I am consistently able to reproduce the Oops on that system.
Since running with this patch, I have not seen the Oops reoccur. I have
also tested it on a Thinkpad X1-Gen12, and that system boots and runs
well with it, but it only has a single Thunderbolt domain, so it does
not exercise the multi-domain failure case.

Fixes: 4f7c2e0d8765 ("thunderbolt: Make sure device runtime resume completes before taking domain lock")
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Gopel <jgopel@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/icm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2024,7 +2024,7 @@ static int complete_rpm(struct device *d
 {
 	struct tb_switch *sw = tb_to_switch(dev);
 
-	if (sw)
+	if (sw && sw->tb == data)
 		complete(&sw->rpm_complete);
 	return 0;
 }
@@ -2040,8 +2040,8 @@ static void remove_unplugged_switch(stru
 	 * tb_switch_remove() calls pm_runtime_get_sync() that then waits
 	 * for it.
 	 */
-	complete_rpm(&sw->dev, NULL);
-	bus_for_each_dev(&tb_bus_type, &sw->dev, NULL, complete_rpm);
+	complete_rpm(&sw->dev, sw->tb);
+	bus_for_each_dev(&tb_bus_type, &sw->dev, sw->tb, complete_rpm);
 	tb_switch_remove(sw);
 
 	pm_runtime_mark_last_busy(parent);


