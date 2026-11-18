Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041705;
	b=Zdn1OoAx98ma5Rjm/uZHX9ANyn+8o2Jvpx1jMZY05HhWBY04q5gC0Ic+aI7mruJ9eRuc
	 ySIKyes4lhpWiQ6OqTqvdNwSAJZEZHoOCDspB5xOw5SJrpFEstha0+f/GGuYyfcMR4nCv
	 NLDtBkDSaXNGN2REfFm5NdKVFF68kxpZt0Tl3c2QZmdvakvu++E3vDHQunZLCM8KzRUYt
	 NY/BYnSJodg23EfdhLIpaKKZDRq0WTIEGwua00NCxUqZzb4eiYTPbH41mrZgk22BW4mWp
	 PKynt4HyVAc4wBL497O1s1ImfYxZfkaL7KubxuP2JYZxJefRXIQ7ZKYUEZ4shQ/ieBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4bDblgYaCmxSFfNM1gg45kIetTnnSZc9RaI6u3GSml8=;
	b=JxaTGSbDUwTjOyqKRAkZ2FZty023HrggZksPzXazKe4uAFcf4uBCU1DnGj+jzd9M1LmR
	 oOzDrS6MnNuDGwtyX15+dvXA3fS2cWeDl5GRyC3wuYQCuSB0kXpgySbsRS3btEVOcl2jp
	 jyY/VmeEQtw4lT5OKaGy19vbyQVnYC/00TQoouq8EL8idTXVkRadmJmHaYaWKHZ3aFj7q
	 yn2/gBlGw/1QSskD+Nk3uQaGx0RutP6ADSE79plx4PiRHCPc0it4Dh8d5eVVvqjHZQAOO
	 q6OZBZk59xJutq5PVqV0uM/cgGsMMLZK5hVzZlUqLTnHw/+WKIo4r06y4RmFjyUzOyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M5W8H0Gh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B75606A31C;
	Wed, 18 Nov 2026 22:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M5W8H0Gh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916041F000C4;
	Wed, 18 Nov 2026 22:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041705;
	bh=4bDblgYaCmxSFfNM1gg45kIetTnnSZc9RaI6u3GSml8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5W8H0GhraJrYqSD77BeFUQ3ezfloA3MvfgxMGBI+UUvOANK39Be/SZYxh6y6LA9G
	 559cAn+ju+3m+Lxy64yqOvtyO3hC1v7luyBGAuzejrP0fHefc4HNcAUfmTqSnKL/0Z
	 /LOo0+lUub6MmCcsUsRJCMcYA4V2lwaasgEJA8zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2892/3318] Bluetooth: btintel: propagate version TLV parsing errors
Date: Wed, 18 Nov 2026 15:58:34 +0100
Message-ID: <20261118150447.264560753@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit 3a74624b5deae7f5e2b98e638687fbf9594a9781 ]

btintel_read_version_tlv() ignores the parser return value, so setup
continues with partially initialized version data after a malformed TLV
causes parsing to stop.

Return the parser error to the caller so an invalid response fails setup
instead of being treated as successful. Keep this behavioral change
separate from the bounds checks so it can be reverted independently if
an existing controller sends malformed data.

Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Reviewed-by: Ali Ahmet Memis <ali@iusegentoo.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: cf87709d7ff8 ("Bluetooth: btintel: Zero version data before parsing TLVs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 8541bfaddd06a..0438bb3f1132c 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -693,6 +693,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 {
 	struct sk_buff *skb;
 	const u8 param[1] = { 0xFF };
+	int err;
 
 	if (!version)
 		return -EINVAL;
@@ -711,10 +712,10 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 		return -EIO;
 	}
 
-	btintel_parse_version_tlv(hdev, version, skb);
+	err = btintel_parse_version_tlv(hdev, version, skb);
 
 	kfree_skb(skb);
-	return 0;
+	return err;
 }
 
 /* ------- REGMAP IBT SUPPORT ------- */
-- 
2.53.0



