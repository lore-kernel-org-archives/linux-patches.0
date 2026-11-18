Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041239;
	b=W4ofDqpYXBIGZQMBCCuQrKNEcFrklLkuwU2yM/v328oyH7eCedodS1dt63e9Yl/FlZ5w
	 8RFtVyUjlyzyy40sQ7rC97lPYgZtitH+Nr2k72nxbGN1pmc+IsQoLZg2AWWvxvj/s5pgZ
	 e+hS4XuwaQNASf0Vskpun/KfApj6CuX+wd2JA28bNitcDYIp8lMPfyPlaN0tF/73hRWUA
	 f2AhJdpIUFqVALgow85PJwJl17FCs20Us+3NrMsit69HUiX4dORjxj3WKmjDhdC46+R/g
	 XZI/2PhanmEaPpA1GrJUeYUiu3aosV8Sy5fVjMM91GWENmQFC+WvvgohMFqUjk663Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yjxqTC+bC8tAeG8Ov/8Tom/RkTsvewJxH6k5ovk/k+4=;
	b=wERiSHgLuOLElHFVJVsYny0ybHNbfvtLLF2DKMqHHAiIbLAIxaPyLuDpN9EXvZbKjmpi
	 089agfmMMuQhbaQmlgLvHoPSqedlKmMDDCAG4Md5F8jrD2zPUcNQAC0/3vjptn5XPiG8K
	 MBj35J5Y+NCGfZfSSZAnf1JgrhMG2giXC2N92CtGI2Aglnxk8i98j878xDNWycQRSue8d
	 ARL6JHtG07wjEZb3kM9+nw8g4QEJa1nTOu/Lnc9nm37fWZnkwO33PvB7YuEAXsqLZDtF/
	 O+fEqWjF7Vm9sh5fmPhfaWsDHKPY4rHPpAoczXKMWaGaZ1rFoqNn2K0Q6/IsUMp5/bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1EeAVyw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E379606A320;
	Wed, 18 Nov 2026 22:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1EeAVyw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53111F000C4;
	Wed, 18 Nov 2026 22:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041239;
	bh=yjxqTC+bC8tAeG8Ov/8Tom/RkTsvewJxH6k5ovk/k+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1EeAVywlIwr7K7IAXUA0nPP5KjTufwNtr+8GmrGJPkIA+9nVg2X+/+/1X5wLg6lh
	 dg9hfur2Qv/Kjx+WEOBOkZE1IBBjNno9F9I/iwy+rCOdhF0ZAwGQPnRtwYIeHlTkS6
	 y3ArL3OXJQ+lHlc65L8hjMdosHPd6cnOUUD5+94Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2742/3318] ACPI: PCI: pci_link: clear driver_data before free
Date: Wed, 18 Nov 2026 15:56:04 +0100
Message-ID: <20261118150443.039927055@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 691c33289b4d7a50b6fe1e03918bfbc21d4641c5 ]

acpi_pci_link_remove() frees the link object without clearing the ACPI
device's driver_data pointer. The ACPI device survives hot-removal and
can later be retrieved by acpi_fetch_acpi_dev(), leaving callers with a
dangling pointer.

Clear driver_data before freeing the link.

Fixes: db89b4f0dbab ("ACPI: catch calls of acpi_driver_data on pointer of wrong type")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260925155846.2381956-1-yaojiale02@163.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_link.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index aa1038b8aec4a..b53d44bc523b8 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -778,6 +778,7 @@ static void acpi_pci_link_remove(struct acpi_device *device)
 	list_del(&link->list);
 	mutex_unlock(&acpi_link_lock);
 
+	device->driver_data = NULL;
 	kfree(link);
 }
 
-- 
2.53.0



