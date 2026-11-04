Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826932;
	b=Fr9C8MWFZ7yq2E7f0UO5K4/GRqK9asjXMT7tXkZn9T2GSntSbcnhRNLzIxdW3MgyOeRA
	 xSN6rd9WIkvbTgQM3yMYlpUB0s2dfiVofYXzqlYlO9IG5qM4GGARkGpReiIafJkyte/gv
	 pNQFjeFLC6rPexh+rM6fHQjGlT5eqeVgGnyamEeoDVVguYtw4i4d2Rpgvm0nAAJRyAYyi
	 QXFHnijYm4nctKUSSa7s4lLSNB3kk0HkYFWHTeYs73TPQMt2wOzMipx6uj5FEn/t1/o97
	 4kgSkgawYHP2gu9zJPmCI2tMBPB0UMNMjQMejGJcx/g6Qdr9JU7pzW1Ma6wqxJ6J4mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Ui0jvI69bT1k9GtOyAGpfA6K8IcN5i3/KBOAnr1hY0=;
	b=wxRgtHghWxQFZF8JVGP8n0DZbXXQy0FRAKCwt90wUXNpEhSsB8V881aMIdLyCpui2qa7
	 aKkA1vuqxYbBejmBsEPvfpswTuYAnUysy+O3iydhpoPZnkON5m5dTxECD5KinTdol8o0Q
	 350g+IJCwr5McvjXG6LAmn+E04oJodh2gcu+QsmHrQtw/6DLm1HG1DHEz3CuLGJfyVgrB
	 0B4uYDWx+XShbk9XsFzYriLo+qxJSy6EtE0JWL2y35BnA5N4kIBI/kJPntOxoVm7yk9FW
	 Fmy2BqNEoHZ0c1YrH2u6/mOy8Z3eHTZzTyUyR7HAkTY+aE6ZYonnVHyLJ3SauCSyzdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okOUTYSt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531E96072FA3;
	Wed,  4 Nov 2026 21:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okOUTYSt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D8F1F00919;
	Wed,  4 Nov 2026 21:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826932;
	bh=/Ui0jvI69bT1k9GtOyAGpfA6K8IcN5i3/KBOAnr1hY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okOUTYStCXG9ekIE1uAGSrA8qt/h7YO2dzrxjBO+jcx8me1g2+VPJ59BH8Yiz4GdP
	 WKHN0GFFQeOkBpM3rAbg1p/xVrl5Wov5vHKB1U8m+KSoVZ7YpY1vL47COls/QpOhE5
	 iNLA66D417a0hcdy7wGDuWv8U5RKOV6OODKqAjZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gopel <jgopel@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.3 091/547] thunderbolt: Do not RPM complete unrelated subtrees on unplug
Date: Wed,  4 Nov 2026 16:04:35 -0500
Message-ID: <20261104211040.811352734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -2072,7 +2072,7 @@ static int complete_rpm(struct device *d
 {
 	struct tb_switch *sw = tb_to_switch(dev);
 
-	if (sw)
+	if (sw && sw->tb == data)
 		complete(&sw->rpm_complete);
 	return 0;
 }
@@ -2088,8 +2088,8 @@ static void remove_unplugged_switch(stru
 	 * tb_switch_remove() calls pm_runtime_get_sync() that then waits
 	 * for it.
 	 */
-	complete_rpm(&sw->dev, NULL);
-	bus_for_each_dev(&tb_bus_type, &sw->dev, NULL, complete_rpm);
+	complete_rpm(&sw->dev, sw->tb);
+	bus_for_each_dev(&tb_bus_type, &sw->dev, sw->tb, complete_rpm);
 	tb_switch_remove(sw);
 
 	pm_runtime_mark_last_busy(parent);


