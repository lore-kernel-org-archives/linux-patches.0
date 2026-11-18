Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022453;
	b=2hZ5sDZbTaythT1pP2RtYMk3Aj1NUYAoi2DPJJBIP7AVdUu1SUpT/eIKS8KhaKCp4Gho
	 WOc7EikfbxnqopPq0SGCI9oI57AfrFNdi7aSgfSy9/5DEH9yUHlAyOrzRIqwX02omhfGa
	 +RiqizrcfiMm93OsuL/VeDIwMgGi/0QkBobpA83RG4OdBujvks+HW02Hx73SY7WVJPVyl
	 5WuWAjprukdukH6ezEydghfzg84/qRRWoCBQWb7/+/aL0UyqzUmA7tDEDUNWyx7CUwoAF
	 Hjg0tl4slYzCZ6+JArKZDl4X05dLWuWUFjzpK6K+TC+7bi29jacJbbjHI0cZgDbsEiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4njkUv5qZMxLTfREpQFpw5OtPGoYD+H9WCGwuKSw72E=;
	b=5d6AI2A72ZgI5H7KnMHf//0Fvqh4spKNEHbocb8gTA9fvhOdKCiP0L/Y8rAIMWnxOKdI
	 k9mLShZS+Up+wrDlFTkwdz1YzJlFs7jNF5oIQ9YTuo0c3fWuxr3JW6WaZLbJNGF6rz37h
	 pfRWAM/p6JQGWoj8nwtGnKVK9+qj6dISkQrvDKFd7mBN5y2yIsc3cwTaR5urYns5Oce22
	 mvWexRd/qr8PEGa5AgjYxmVfb9LJJOL2S8RNwz4FVTD30AxjalJrAon6A+p//7NROYfFA
	 9rJp4nWC1LUEaMqecHPsVqUdENrJ716WPMrORaFCMFPZ61/h6qOne4Pgk+1fJHxXPHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LF6L8TgL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82BC606A332;
	Wed, 18 Nov 2026 17:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LF6L8TgL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C041F000C4;
	Wed, 18 Nov 2026 17:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022453;
	bh=4njkUv5qZMxLTfREpQFpw5OtPGoYD+H9WCGwuKSw72E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LF6L8TgLJL3ylCK0RZ/rFLXJEPa0iSenWW6z72uPc6d8QnRqAmJCqRBikbice27JG
	 mVIQyffy8PC7dRyg6Qentz/rZhg8nE8zF6pUKEsEkkw7IvmsPBze8p3sD0CZfdB7XO
	 ySbjCoFSKU4a7u4khC3H1low1WuO8rr134MDh6Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0019/2151] PCI/pwrctrl: generic: Fix leaking array from of_regulator_bulk_get_all()
Date: Wed, 18 Nov 2026 15:29:14 +0100
Message-ID: <20261118150122.345534116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit ee450e3a2d334c7e6383d8a55ad2d53b3822bacc ]

of_regulator_bulk_get_all() allocates the consumers array and returns it to
the caller, who is expected to free it at an appropriate time.  PCI pwrctrl
never did, leading to a memory leak.

Add an explicit kfree() for the consumers array.

Fixes: 75996c92f4de ("PCI/pwrctrl: Add pwrctrl driver for PCI slots")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260930-pci-pwrctrl-kfree-v1-1-f09bbffd8da3@flipper.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctrl/slot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pwrctrl/slot.c b/drivers/pci/pwrctrl/slot.c
index 51de1eecdb26b..35bbf8a380415 100644
--- a/drivers/pci/pwrctrl/slot.c
+++ b/drivers/pci/pwrctrl/slot.c
@@ -25,6 +25,7 @@ static void devm_slot_pwrctrl_power_off(void *data)
 
 	regulator_bulk_disable(slot->num_supplies, slot->supplies);
 	regulator_bulk_free(slot->num_supplies, slot->supplies);
+	kfree(slot->supplies);
 }
 
 static int slot_pwrctrl_probe(struct platform_device *pdev)
-- 
2.53.0



