Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE308F49;
	Sat,  9 Nov 2024 00:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731112111; cv=none; b=LtS2UITQw5UkYeFB269FQ8Z8LOjvQbIzxiaMtrB5+sCQ1loh2MJfQA3HaDWTdlkzViLFLSqtvvOZsFTm3xnb7h4372pMeWqPI5dgDE520RH6Wlpedr7ClkfpCyCnUmBz15tQJGQNMquOw2vQCVgctYS1dyF7+3aLbWX7MXhtJhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731112111; c=relaxed/simple;
	bh=EWIW2i2N7eAAxcCgqkKrlpW0rLZ1if4K4lcBruXdEwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GYdMys4dRPFAQPhEuJ034L+qBbMY0bZ+m2IzUZyVx02LzfRgrma/jnFVNmvSMcjvzDnL/xzm6DBqA5obtR8T6Izhw0xTuIueu/GkSoGzZ9PV18uL/8TLHutWh8SnoFbad2oq/NTxC9rs1QcOQPxmHEzD61QrBVBamNRno/F4E1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDyNYGce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDyNYGce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8800DC4CECD;
	Sat,  9 Nov 2024 00:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731112110;
	bh=EWIW2i2N7eAAxcCgqkKrlpW0rLZ1if4K4lcBruXdEwQ=;
	h=From:To:Cc:Subject:Date:From;
	b=eDyNYGceRPr0uF5gGYTsLy6tTSAgODed4ZMOHlGux8BTmFYcDJLR7/3KXpiECFdK1
	 uY6WJRc5Uuj2LRfawidKCxONp5c0YWt0s6E7hRRsSoZEvcRuhjYhAh82PbKma6CRyW
	 btLfb3vMqXT7RbJ9cNAVXGkNwSvs8wV85KKtNFxPbXN+V/n3yJdgMHNMhqbrL9ZtxZ
	 PLxS1uvuNo97YrM7TzkyISHZ0QFG2SHszsR3KjIs32SP2gLVpfZgU+ctZ3tBQto52Y
	 bhiGjO0NqJNEmtmitadQC2sNHpY6QJsOwgzbSOcfCDXXbFTFRIeNCszXHO44Zw4dej
	 uXqJgpmRFVgag==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/3] SPMI patches for the next merge window
Date: Fri,  8 Nov 2024 16:28:25 -0800
Message-ID: <20241109002829.160973-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg,

Please apply these SPMI patches for the next merge window.

 - Compatible string updates for SPMI bindings
 - Use scoped version of for_each_available_child_of_node() to avoid
   leaks

Dmitry Baryshkov (1):
  dt-bindings: spmi: qcom,x1e80100-spmi-pmic-arb: Add SAR2130P
    compatible

Fei Shao (1):
  dt-bindings: spmi: spmi-mtk-pmif: Add compatible for MT8188

Javier Carrasco (1):
  spmi: pmic-arb: fix return path in for_each_available_child_of_node()

 .../devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml         | 1 +
 .../bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml          | 6 +++++-
 drivers/spmi/spmi-pmic-arb.c                                | 3 +--
 3 files changed, 7 insertions(+), 3 deletions(-)


base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

