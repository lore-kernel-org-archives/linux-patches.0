Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061137;
	b=BXlwpI7RB5hbEBainTZA2JhtRc8CmI699ycjRlf9qBx24ZE7PlIvhCtSqJGqlrwjwpfa
	 XAxYoalO/wkFz6W15pm6jW5dP6Gedf0ufFGeTEX8JlrSNTejXjM8Lb2+pyg6gPIu9Ri2N
	 4HJ/6f9+UHI99ygFRE98Olj2mEZQRe9VcUFus3dc1p8ymYPHk5FwQwIk9+LXLcW1QxXh7
	 q1kuqOYLdRM8cG7rRSUeAfuo5QGUb4mFla9tFKjAlTjLjXk8kqYndO3EglJmAA73M0Q8d
	 YY6C/d3OEnHQXX3RljwFcXYEkg9sN+3L2iGji4j2T8S3kw6Y+VBZGH8ES55ghM27DxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X8eUw6q5qPyTXuZlwEG/slsMtIht3kmp7ECDjjyepNk=;
	b=X4aSD7Py+1Wc3pwiKFWRBmH+Ef7m8+XasHyoM89sUKoxFTMhgdai7gffOpwPxp79UUOF
	 2tGNz7qcMrej9DOlqWbkrFjezYQox7sIKLo/RTKLhTZEjormBXpq3QxIMLOGlzRZR0OJd
	 afzHQqq/8lP3pFPO9j61Z8OC7WbOgUyh5Y3VDU88fM68nyzwwrpEVTS413Zi6C7JR8nUn
	 sCAASSJoTosj8ISNRjefYbWzsjmNi2ipglUVbTaUDwLp/9l045fK6AwfcAE6kO/TNAK6S
	 VtaqHma/6lt+pO9YDgH+IcStqyJ9t/vWQP8aS5HOBt73DMnehQJ4No+8tsVAYWhJugw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZSSZH/aw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF44606D817;
	Sat,  7 Nov 2026 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZSSZH/aw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591D11F0089F;
	Sat,  7 Nov 2026 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061136;
	bh=X8eUw6q5qPyTXuZlwEG/slsMtIht3kmp7ECDjjyepNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSSZH/awLb/PToLsYtFTcqAgnW42FvJtNTLSCprrfpD2p/0GiBfPeR63+y+mPq4gq
	 HKjYTOiGuGQovBGs6ca6iPAAyXpavTYtTnpRXQX7oML3LQwsRCKbAB311qFhdsIn6G
	 hcJCe2aziH8td9onzBXl2N/eU6gniMXQTNjUARyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gopel <jgopel@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 0445/1536] thunderbolt: Do not RPM complete unrelated subtrees on unplug
Date: Sat,  7 Nov 2026 08:41:01 -0500
Message-ID: <20261107135010.042187849@linuxfoundation.org>
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
@@ -2034,7 +2034,7 @@ static int complete_rpm(struct device *d
 {
 	struct tb_switch *sw = tb_to_switch(dev);
 
-	if (sw)
+	if (sw && sw->tb == data)
 		complete(&sw->rpm_complete);
 	return 0;
 }
@@ -2050,8 +2050,8 @@ static void remove_unplugged_switch(stru
 	 * tb_switch_remove() calls pm_runtime_get_sync() that then waits
 	 * for it.
 	 */
-	complete_rpm(&sw->dev, NULL);
-	bus_for_each_dev(&tb_bus_type, &sw->dev, NULL, complete_rpm);
+	complete_rpm(&sw->dev, sw->tb);
+	bus_for_each_dev(&tb_bus_type, &sw->dev, sw->tb, complete_rpm);
 	tb_switch_remove(sw);
 
 	pm_runtime_mark_last_busy(parent);


