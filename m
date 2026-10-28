Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213425;
	b=HhOD8Q+v21li/OS6IHnJMozuFREMz6Sr5Jn0uPzBqLTHNMx1wrgaHxsau0/URyqZlxfp
	 G/YghYpSZRqkXJbGdUZjiClW04Yj5T9IhyCINGihy5eU6Spv24syAvlsavimOiiqwPHc3
	 4AySVztWk83OK230R91kBxgx3sQUP1K26MRDoGCZNim44KqREFjTGeyofszBdQJn4UPR5
	 Rtpbl+6koAqJkfp6pJ527cmstaAOVS33yGkIwq5znY5FfjGEp3OXhZdMFOCmI8gV6EdJH
	 zczHANdl395E3nnfK7dmxmN7LfVHD+9iiAPR7AjOtfCPgk+NdVXzjb9zO8nTkmjNkwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SYJl6x7FafoJB0oJGo+WsTCZ8j6ic0UmRdHgO0r2Xxc=;
	b=orTRQFvc5LQj6puzmOh1pET0b6i3+soGr5j70cZcmBR7RsJuAoq96baJkDQhVjttCPBn
	 AyEj6AvncgwSv7EtrVS8i4ONekjg3oMbVMFnG4Eoz/FN4IU12iB+6dJqSI7ueczPrIZAG
	 tTvNIPmhYm9ZQWokrE0ZFGIDzT8Z1/PX72bgoyVehyLAIkHWxSNn59lNxUG5UnuDL6y7h
	 xixlyR/dScfmVKD00QUqJoVrfsuqh9Q3dbaq2iivXW9Au3ILPteSBYSLyq5SF5zZP6UAn
	 E+ctYsOu3/br6gLRzCwyl5OvD28lnX4OF1Mb501HyIbErGhV0g+94UtoSpGVm52YA4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZgYV/su8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E56606A31A;
	Wed, 28 Oct 2026 18:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZgYV/su8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A22D1F01825;
	Wed, 28 Oct 2026 18:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213424;
	bh=SYJl6x7FafoJB0oJGo+WsTCZ8j6ic0UmRdHgO0r2Xxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgYV/su81SVO3D8U3V2J5dSDHcWoEriK/TZraR8bIFxQAyzUi11nQkZNqThLqtegl
	 DQTGHLhJKsf+314Hd71EMSKhNBAqOffcfhwCtCy6y7gXexR6fHUCbrBJspZmScbYCA
	 zKxL3WABSvU2REfb/oq8arxTR94mdQU5FEUk+FVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0484/1887] gpio: exar: initialize the ID before registering its cleanup
Date: Wed, 28 Oct 2026 17:43:00 +0100
Message-ID: <20261028170510.277048235@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 4d69e74034b208588636ecc177e0dd43a7696af3 ]

devm_add_action_or_reset() invokes the cleanup action immediately when
registering the action fails.  gpio_exar_probe() currently stores the
allocated ID in exar_gpio only after registering the action, so that
failure makes exar_devm_ida_free() release ID 0.  If the allocated ID is
nonzero, this leaks that ID and can free ID 0 belonging to another device.

Store the ID before registering the cleanup action so both the immediate
failure path and normal device teardown release the correct allocation.

Fixes: 5300ebb695fa ("gpio: exar: use devm action for freeing the IDA and drop remove()")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/179070265834.12871.48183786512201899.idr-bug-79@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-exar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-exar.c b/drivers/gpio/gpio-exar.c
index e641bc96c4e71..0096f8a9377bd 100644
--- a/drivers/gpio/gpio-exar.c
+++ b/drivers/gpio/gpio-exar.c
@@ -196,6 +196,7 @@ static int gpio_exar_probe(struct platform_device *pdev)
 	index = ida_alloc(&ida_index, GFP_KERNEL);
 	if (index < 0)
 		return index;
+	exar_gpio->index = index;
 
 	ret = devm_add_action_or_reset(dev, exar_devm_ida_free, exar_gpio);
 	if (ret)
@@ -211,7 +212,6 @@ static int gpio_exar_probe(struct platform_device *pdev)
 	exar_gpio->gpio_chip.set = exar_set_value;
 	exar_gpio->gpio_chip.base = -1;
 	exar_gpio->gpio_chip.ngpio = ngpios;
-	exar_gpio->index = index;
 	exar_gpio->first_pin = first_pin;
 
 	ret = devm_gpiochip_add_data(dev, &exar_gpio->gpio_chip, exar_gpio);
-- 
2.53.0



