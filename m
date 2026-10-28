Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214249;
	b=uIIsWNHByS8yJBd+PY+hJ0CW7EGLZBVreeCX3kQaKTXuF2xB7iom5x2bKnIJh3Tes4dn
	 UUbX/gTpSMGKlnloorb7DKsM4QiKjfHVx3W9gPoXhnTVjo2zbVTPsDws75fa41uCaiwn/
	 gXS1OhPxGqwSbOKM27FtXBg7GOk1SiuhVGmzZuRdxAWnlBWzSLzFZwebLVIsVWkp1Hkrh
	 i4D4SF56OEzv08nSg0U8wm6bs0+lUCQvye2oGjbcvsQJwVykmIO34ZzPyckHGn6NMxL69
	 FVFLANQGeCvXCPDmJNA/xqGgdZwtuE/vOljoMWMTsM1yHYTgvb9Igip0wqhHISxXa9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mbpEZ7r+3VJfx2vWIfbPb0oOoe//QqS8nfUj3OHF+sI=;
	b=B+tuF0Co2ltcfIWCcxyBw9auj4YuBDADkYHFgOejBXex9T3iFlM+YPV8hIalVBWip+ST
	 QuXx86PIxc/iAZvPAoVWKoPFvBZXMciqxSkP04NThrk0XvVtH/6a3M1Ch63DuSP63ume4
	 HoJ+GOmbbWBihUB53OeYuKaHbZepahNrzOS9jATsoxB6UAXrTbMuRGsx8PLkiEQoaXcJZ
	 US10lucqAAMOqH+GFsBJJyFXwVLrD/SstQm1lQ0IGkFlqFJCq6HI/AXUr3ST/TRZb6f5B
	 BJSgebRZ9KZovGzEe5vImW3gdjPmuwUSPhB1PdMfdpXRmM0gD38tSp/vjv1SLVgcq8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fsj+tWUa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D434606A31D;
	Wed, 28 Oct 2026 19:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fsj+tWUa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD0B1F01829;
	Wed, 28 Oct 2026 19:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214249;
	bh=mbpEZ7r+3VJfx2vWIfbPb0oOoe//QqS8nfUj3OHF+sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fsj+tWUaslqL18PvLaKDeZcrQnyLO2RanlFRnoxlmoiS6aT5sc1amauWOl66v9HPI
	 lv42MY5w9kk24VbsdE+Pc2a9utvkZY4LBdLCNTwcfCV5LUXMXP6JJ84OHRacj+h3Q2
	 O2jyIT4wnSD0KBucDmIvRZrlpkWMuLziX6tiak+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Christian Bruel <christian.bruel@foss.st.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0791/1887] PCI: endpoint: pci-epf-test: Fix double free that causes kernel to oops
Date: Wed, 28 Oct 2026 17:48:07 +0100
Message-ID: <20261028170517.433281711@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit 934e9d137d937706004c325fa1474f9e3f1ba10a ]

Fix a kernel oops found while testing the stm32_pcie Endpoint driver
with handling of PERST# deassertion:

During EP initialization, pci_epf_test_alloc_space() allocates all BARs,
which are further freed if epc_set_bar() fails (for instance, due to no
free inbound window).

However, when pci_epc_set_bar() fails, the error path:

  pci_epc_set_bar() ->
    pci_epf_free_space()

does not clear the previous assignment to epf_test->reg[bar].

Then, if the host reboots, the PERST# deassertion restarts the BAR
allocation sequence with the same allocation failure (no free inbound
window), creating a double free situation since epf_test->reg[bar] was
deallocated and is still non-NULL.

Thus, make sure that pci_epf_alloc_space() and pci_epf_free_space()
invocations are symmetric, and as such, set epf_test->reg[bar] to NULL
when memory is freed.

Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Link: https://lore.kernel.org/r/20250124123043.96112-1-christian.bruel@foss.st.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index fb47ce721e095..53f1236cd91d7 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -735,6 +735,7 @@ static void pci_epf_test_unbind(struct pci_epf *epf)
 					  epf_bar);
 			pci_epf_free_space(epf, epf_test->reg[bar], bar,
 					   PRIMARY_INTERFACE);
+			epf_test->reg[bar] = NULL;
 		}
 	}
 }
@@ -769,6 +770,7 @@ static int pci_epf_test_set_bar(struct pci_epf *epf)
 		if (ret) {
 			pci_epf_free_space(epf, epf_test->reg[bar], bar,
 					   PRIMARY_INTERFACE);
+			epf_test->reg[bar] = NULL;
 			dev_err(dev, "Failed to set BAR%d\n", bar);
 			if (bar == test_reg_bar)
 				return ret;
-- 
2.53.0



