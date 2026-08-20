Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4DC47F774;
	Thu, 20 Aug 2026 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248524; cv=none; b=mNXT4H2zQHB2BEqlbk+5jh1pLHV/MNn4aL3jmSe3pK6U6fnXL34S1yFa9qFeIFrfOhXJWHx948c/wK88KxQ55Y3kTDAbTSv4mEQKCPJD9fMiNjDPs3GmT9z64BgayLBQLdynnRxS5j5XNLYRVYB0B3ZHoXHjC0uV82iJM0NSfro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248524; c=relaxed/simple;
	bh=yZhtTs0eK6mwia8E3WvcJiCZfqQYD7PbuC03D/WbrR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bY2o9exUC4fjcgobozXpn6vQG3lZ6TZFUSdJ7wM8Travpv2bqzXm9x9DVyLWpbHODDfue+1jE4ZLlppeOVaOZTBSsN9f2eEvF2eneof2xivwCNzLOyIlZp6m341ATK7U/oBfPY75ReaV0X6TA0jOjKesocOgNzXw+svEvjhivXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mN8z3KeP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mN8z3KeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1489C1F000E9;
	Thu, 20 Aug 2026 17:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248523;
	bh=vKLdTDDeT6EkTJ82FsI2JpD1oYvKuXRIrOyUmlfKWRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mN8z3KeP0z88Gj+ZMsEhxZZ+Ly3+oaTjM0dVAzZcySasSiH6vRHzHJ8UCuUU3X5X1
	 3zFfXTllskFX326K2qLRf4vJgAZwNefLCoSah+iO9/A8H40/brZcb+i4aeP6+t87IL
	 aKVv9TyOLUn3ztUtRjKvj4D23ljcEvcqjF0f0lZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 257/303] i2c: bcm-iproc: remove printout on handled timeouts
Date: Thu, 20 Aug 2026 16:56:33 +0200
Message-ID: <20260820145301.170494924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 796e2c260187e32530cf343546ba1cdf2e2f5491 ]

I2C and SMBus timeouts are not something the user needs to be informed
about on controller level. The client driver may know if that really is
a problem and give more detailed information to the user. The controller
should just pass this information upwards. Remove the printout.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 98f2e9e6d6f9 ("i2c: iproc: reset bus after timeout if START_BUSY is stuck")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -811,8 +811,6 @@ static int bcm_iproc_i2c_xfer_wait(struc
 	}
 
 	if (!time_left && !iproc_i2c->xfer_is_done) {
-		dev_err(iproc_i2c->device, "transaction timed out\n");
-
 		/* flush both TX/RX FIFOs */
 		val = BIT(M_FIFO_RX_FLUSH_SHIFT) | BIT(M_FIFO_TX_FLUSH_SHIFT);
 		iproc_i2c_wr_reg(iproc_i2c, M_FIFO_CTRL_OFFSET, val);


