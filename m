Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048630;
	b=Nnts19miGEuNZ4UztXmJm74kUqPwXzcZArh5QJ2/gGrN6OVp5RSpo3nEb9mdli67dFoC
	 RApRiAFFceMQfzq/L+A4WUUZ+UFyofGkt9ns5Ou5yWGyMcWCzeSQVkNFyy2nAiWuJFblW
	 sE/BO/ihQuiEtcJpwO3p2g7RopoU4dJyElzsq9EwEQ7kAPwC5Chfj9ydpcbSn0h8gXEUL
	 wwoeG+mDvUcT3UAD8yAAJiTJ7WpDEOw7Qcs9MB/MKMIyOyLn6S61ah86ksAa5+rOku+U6
	 xl4v5dn4/TCOjmUXPQgWroX9ZGYSQm4HIu39ERQeSt/xm5sDoDOzVUPIeTXx/a8ZBug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nhsElPiCKbSvNjrSh+S6yVBOmZfJZJDz+CY6o1xAsS4=;
	b=D15yl2rLeMncRVSg4+fs0uyovj8sMYczPk0wXcATZI4I1wdh9tQCnJKQUj18I+FdDvjU
	 rxag4Wo5i60cRV+lbb47A2aHY8NqXUXV0+tdefGmbY/DbF3sMFivc5+prUpzm/ehBKxca
	 uoeOMUPvUgUvp4ogCtmIxaJ6mhFb0cjdBIfpwvCt+b3XOuIcF9lRhT7A7hmHafDO5h1nf
	 5HY0HmF5vGTHn2aoEx7/ITaXF9ZqAdc4BePXzCrlhjRaTkk33M3J3wm3TaAHToQyMiklP
	 YfczTnekqm+FCEn2R+WiYE896JRvlkDqfDKTIqxY5fuC51bX7TamM+vE+6RGvhiSvfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XyMz2Sxx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EA6606A320;
	Thu, 19 Nov 2026 00:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XyMz2Sxx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0961F000C4;
	Thu, 19 Nov 2026 00:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048630;
	bh=nhsElPiCKbSvNjrSh+S6yVBOmZfJZJDz+CY6o1xAsS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XyMz2SxxGfqx6xnQ9Sr8UHAl6jRzLyeLkKlUiavomNm+JuL497CFWcI7X/LTH4vNh
	 RlijF4F/F8f0Jj4L0MLgvYtt1NHsA8moLmOHv5vFk/LoT6jflLqf+6XwMfa2Sr4hf/
	 skjlXMzDe/m1Vsun5/jm9cfbnbvPq5GGwheApIm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2062/2857] ACPI: PCC: Setup PCC Opregion handler only if platform interrupt is available
Date: Wed, 18 Nov 2026 15:51:36 +0100
Message-ID: <20261118150315.661870413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit a10b1c99e2dccee69838b512419843c21b2b87f8 ]

Currently, PCC OpRegion handler depends on the availability of platform
interrupt to be functional currently. If it is not available, the OpRegion
can't be executed successfully or the desired outcome won't be possible.
So let's reject setting up the PCC OpRegion handler on the platform if
it doesn't support or have platform interrupt available.

Signed-off-by: Huisong Li <lihuisong@huawei.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 46c263c21387 ("ACPI: PCC: Preserve shared memory signature in OpRegion handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pcc.c | 47 +++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/acpi_pcc.c b/drivers/acpi/acpi_pcc.c
index 3e252be047b85..07a034a53acac 100644
--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -53,6 +53,7 @@ acpi_pcc_address_space_setup(acpi_handle region_handle, u32 function,
 	struct pcc_data *data;
 	struct acpi_pcc_info *ctx = handler_context;
 	struct pcc_mbox_chan *pcc_chan;
+	static acpi_status ret;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -69,23 +70,35 @@ acpi_pcc_address_space_setup(acpi_handle region_handle, u32 function,
 	if (IS_ERR(data->pcc_chan)) {
 		pr_err("Failed to find PCC channel for subspace %d\n",
 		       ctx->subspace_id);
-		kfree(data);
-		return AE_NOT_FOUND;
+		ret = AE_NOT_FOUND;
+		goto err_free_data;
 	}
 
 	pcc_chan = data->pcc_chan;
+	if (!pcc_chan->mchan->mbox->txdone_irq) {
+		pr_err("This channel-%d does not support interrupt.\n",
+		       ctx->subspace_id);
+		ret = AE_SUPPORT;
+		goto err_free_channel;
+	}
 	data->pcc_comm_addr = acpi_os_ioremap(pcc_chan->shmem_base_addr,
 					      pcc_chan->shmem_size);
 	if (!data->pcc_comm_addr) {
 		pr_err("Failed to ioremap PCC comm region mem for %d\n",
 		       ctx->subspace_id);
-		pcc_mbox_free_channel(data->pcc_chan);
-		kfree(data);
-		return AE_NO_MEMORY;
+		ret = AE_NO_MEMORY;
+		goto err_free_channel;
 	}
 
 	*region_context = data;
 	return AE_OK;
+
+err_free_channel:
+	pcc_mbox_free_channel(data->pcc_chan);
+err_free_data:
+	kfree(data);
+
+	return ret;
 }
 
 static acpi_status
@@ -106,19 +119,17 @@ acpi_pcc_address_space_handler(u32 function, acpi_physical_address addr,
 	if (ret < 0)
 		return AE_ERROR;
 
-	if (data->pcc_chan->mchan->mbox->txdone_irq) {
-		/*
-		 * pcc_chan->latency is just a Nominal value. In reality the remote
-		 * processor could be much slower to reply. So add an arbitrary
-		 * amount of wait on top of Nominal.
-		 */
-		usecs_lat = PCC_CMD_WAIT_RETRIES_NUM * data->pcc_chan->latency;
-		ret = wait_for_completion_timeout(&data->done,
-						  usecs_to_jiffies(usecs_lat));
-		if (ret == 0) {
-			pr_err("PCC command executed timeout!\n");
-			return AE_TIME;
-		}
+	/*
+	 * pcc_chan->latency is just a Nominal value. In reality the remote
+	 * processor could be much slower to reply. So add an arbitrary
+	 * amount of wait on top of Nominal.
+	 */
+	usecs_lat = PCC_CMD_WAIT_RETRIES_NUM * data->pcc_chan->latency;
+	ret = wait_for_completion_timeout(&data->done,
+						usecs_to_jiffies(usecs_lat));
+	if (ret == 0) {
+		pr_err("PCC command executed timeout!\n");
+		return AE_TIME;
 	}
 
 	mbox_chan_txdone(data->pcc_chan->mchan, ret);
-- 
2.53.0



