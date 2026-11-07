Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063145;
	b=cDN2+5Ub4iyWClSBOYzmvqkC3Md5EZ1KPh3gGZQaLmCW1WdsLh2VpDDJ3gaQ8gmgED9Q
	 vowe2FwY0LWQBrD9ACdd0rlY9d95zP6SebAKzsRE+/Y/lVpV08sZ3no9zlCXsOEGE+7Z1
	 THSTvXF0h/p8yDUEyRHG7Oey8us/JI4SorP2Mcl+hdDoqg09B9TVDYmJ+MufwDPcyktAy
	 ReifGg4zVyWj1JYIhTTD5CvUGhb6PkNv5m3XoMdL7hJN9YS+/M9iiH7kPk9UbUlUMKbW7
	 y5N4F4JvyAw24OipNKlp+zj8pmvVOvU3yhY7R89AmEmFIoydn/cFEae4sJZYQYCUzVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6sAovY+0DemWZsMNLoBD698eZwCUm4IE8wYbZPYnqso=;
	b=GwYeGZBmzQzPbcDcWoFv5WPon25WiNzlhoZbvb+DMT9iCsay3BuRcuw+4BSenif2XNQf
	 UChYAGs1cxClr1e9rFF126ngbCLdyU7Nv5VVgogkkxMgneIYW1lJrdG1ZXO6jNDXugz2T
	 asExSQyomF7fz3AdXm2MfQvotjFk1zlfu7qbacVFAUsrNdsnwK2jm875tjQ2puniZipgK
	 Q+VpdfJwyn5WBJJY4f0DjbUqKGmOCxoLv84j2FDWIGv+Q2Xb8S+gd7cY31YCBbpVsNQqa
	 HsBe8A+8xUl75pbv5lmHsIDNsTpmd1+Yia0pL1igCAf/VXYGPKKiPDcNOv9wDZVPD0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDhht10v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DBF606A326;
	Sat,  7 Nov 2026 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDhht10v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED0F1F008A1;
	Sat,  7 Nov 2026 14:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063144;
	bh=6sAovY+0DemWZsMNLoBD698eZwCUm4IE8wYbZPYnqso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDhht10vg8anBRKLpx3VwL74NDMKEfpxlRp1VEFfVHdB6QbgSmn8NXadR6zE8uLEy
	 uBC7yUsJ6TqKif+SkGNV74rFFBCYzEDGcaoUBamHZPGK07QNNjc8H+O4//38V0Ttu7
	 FTx9kQTmfn+eANXw8ykTJ0n14t9u5xIlh4IfdzM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair@alistair23.me>,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 371/869] PCI/DOE: Fix double free of a duplicate features sysfs name
Date: Sat,  7 Nov 2026 08:50:53 -0500
Message-ID: <20261107134905.378682894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 624ee129620a054466b6a29d98cd7a40ccc239cd ]

When a DOE feature is reported twice, sysfs_add_file_to_group() fails
with -EEXIST for the second copy and pci_doe_sysfs_feature_populate()
frees that attribute's name, but leaves the pointer in place.
pci_doe_sysfs_feature_remove() frees every name again when the device
is removed, or when a later feature fails to register, so the name is
freed twice:

  BUG: KASAN: double-free in pci_doe_sysfs_feature_remove+0x117/0x1b0
  Call Trace:
   kfree+0x11a/0x420
   pci_doe_sysfs_feature_remove+0x117/0x1b0
   pci_doe_sysfs_teardown+0x90/0xf0
   pci_remove_bus_device+0x128/0x2e0
   pci_stop_and_remove_bus_device_locked+0x1d/0x30
   remove_store+0xd2/0xf0

Clear the pointer after freeing the name.

Fixes: 2311ab1820fe ("PCI/DOE: Expose DOE features via sysfs")
Suggested-by: Alistair Francis <alistair@alistair23.me>
Assisted-by: LLM
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261003102221.59894-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/doe.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/doe.c b/drivers/pci/doe.c
index aae9a8a00406e..3b0cc6db4402d 100644
--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -210,8 +210,9 @@ static int pci_doe_sysfs_feature_populate(struct pci_dev *pdev,
 				pci_warn(pdev, "Failed adding %s to sysfs group\n",
 					 attrs[i].attr.name);
 				goto fail;
-			} else
-				kfree(attrs[i].attr.name);
+			}
+			kfree(attrs[i].attr.name);
+			attrs[i].attr.name = NULL;
 		}
 	}
 
-- 
2.53.0



