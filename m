Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040191;
	b=IzBR0qyk/GPhEy6PqG15hNjirEWAcuR8l7HAPSA8k69+hduDSWf0eWpo8HD9dRQ7h5bt
	 Wd32vh1Hodh/oSk0HpeJBKYJdGRAMUl1aLhqzGK2G3/f2bYsROwYTh569Et17SFdj/gOM
	 BcyRHWEOBcZLht4zTJmib0OKg/wMjffOH8s+7F+s2r1uH5pW5OiVC+Bgs0lZvQvvxait3
	 AvCdwq+BEIQVu1PicTHWF6kocRu8Q95jzHETebausXPUQGVzuxw6Bcy4ORuLQnaJO8/ZR
	 CA4McApN+2N14hudYueY9YiQOWx1HR7eHUn5/Dj4RL+1clAhpJB/lIuQbBMhkQgArpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8CRAi3jQoAIVUymAHfn93GcfJG7xfDO4Ak+Pn2pQBz8=;
	b=ZapbC47nHc1tOiFBVVq2t+4qQzDEDvL9SugjGhmY+a/FSEnAZqqpS18wvm/Ch208U2Qd
	 sYNRKJZCjRz29Y2BdS55Co+b537X1m3RocOFlLPF85ZfDIsT2W80cQTGr0BHEXmcTdWrQ
	 ZIIcs4rumGQf9sSjep9cLfFKW7zTixuh/tIofmQ7u/tHiTPqwwzDwIb5r8QmMuKGs+3BZ
	 v6or4LwRQO1Wvt1rr5ZExrzAnH/5XCYz/ERfzSrfM+wWJvxaO2BsDzChV/E2kEEW3Z0de
	 MCnd87e44W+eLW/TMb1VX7CDhWsOOnDWsnJCoU/8Yyz5sCHosxbs0YdZec9r0/NC16A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boREz14h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213D7606A31C;
	Wed, 18 Nov 2026 22:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boREz14h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B291F000C4;
	Wed, 18 Nov 2026 22:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040190;
	bh=8CRAi3jQoAIVUymAHfn93GcfJG7xfDO4Ak+Pn2pQBz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boREz14h+xadnPtSCA2LMVHa5UWPjrAy9+YziVcINxkN4sWF5BHg3rKz8gB7jkjHQ
	 F9K1N98po4kMfwKpkWI7Ic0qEUetwGgLbum/dWiByJLyfM9+jexwFHP/KeLoGgz21b
	 n6lMSDftArWdBZkXXHBB2RVHIZJpU0+01fOH0b0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2370/3318] ACPI: PCC: Simplify PCC shared memory region handling
Date: Wed, 18 Nov 2026 15:49:52 +0100
Message-ID: <20261118150432.663417824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 8960c45a0f41399770d408921180231395604e2f ]

The PCC driver now handles mapping and unmapping of shared memory
areas as part of pcc_mbox_{request,free}_channel(). Without these before,
this ACPI PCC opregion driver did handling of those mappings like several
other PCC mailbox client drivers.

There were redundant operations, leading to unnecessary code. Maintaining
the consistency across these driver was harder due to scattered handling
of shmem.

Just use the mapped shmem and remove all redundant operations from this
driver.

Tested-by: Adam Young <admiyo@os.amperecomputing.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://patch.msgid.link/20250411113144.1151094-1-sudeep.holla@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 46c263c21387 ("ACPI: PCC: Preserve shared memory signature in OpRegion handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pcc.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/acpi_pcc.c b/drivers/acpi/acpi_pcc.c
index 59d2308259cb2..e3f302b9dee5f 100644
--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -31,7 +31,6 @@
 
 struct pcc_data {
 	struct pcc_mbox_chan *pcc_chan;
-	void __iomem *pcc_comm_addr;
 	struct completion done;
 	struct mbox_client cl;
 	struct acpi_pcc_info ctx;
@@ -81,14 +80,6 @@ acpi_pcc_address_space_setup(acpi_handle region_handle, u32 function,
 		ret = AE_SUPPORT;
 		goto err_free_channel;
 	}
-	data->pcc_comm_addr = acpi_os_ioremap(pcc_chan->shmem_base_addr,
-					      pcc_chan->shmem_size);
-	if (!data->pcc_comm_addr) {
-		pr_err("Failed to ioremap PCC comm region mem for %d\n",
-		       ctx->subspace_id);
-		ret = AE_NO_MEMORY;
-		goto err_free_channel;
-	}
 
 	*region_context = data;
 	return AE_OK;
@@ -113,7 +104,7 @@ acpi_pcc_address_space_handler(u32 function, acpi_physical_address addr,
 	reinit_completion(&data->done);
 
 	/* Write to Shared Memory */
-	memcpy_toio(data->pcc_comm_addr, (void *)value, data->ctx.length);
+	memcpy_toio(data->pcc_chan->shmem, (void *)value, data->ctx.length);
 
 	ret = mbox_send_message(data->pcc_chan->mchan, NULL);
 	if (ret < 0)
@@ -134,7 +125,7 @@ acpi_pcc_address_space_handler(u32 function, acpi_physical_address addr,
 
 	mbox_chan_txdone(data->pcc_chan->mchan, ret);
 
-	memcpy_fromio(value, data->pcc_comm_addr, data->ctx.length);
+	memcpy_fromio(value, data->pcc_chan->shmem, data->ctx.length);
 
 	return AE_OK;
 }
-- 
2.53.0



