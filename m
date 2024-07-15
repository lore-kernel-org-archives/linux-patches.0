Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F9E2572;
	Mon, 15 Jul 2024 01:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721007029; cv=none; b=e2oAVkE0GSmTLBEb+R0regXc3E/GcB3xE4B3o2jwpaarkompNk7qkbV2pjFPGJroBAfzWfbtFEQnmxVV8nSf/Ek5lVqPH+tO3eMPcHCpy0kRF5NqoBl5KzHCiG+pvvJctnLodER04wIuVcse4xN9NviyMKPRqTO4+akk5Ykysqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721007029; c=relaxed/simple;
	bh=3J8FPMqzJIfW3Jf7Y2r8LOIK9hZQF2BFPJ51MsnHNzk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=arnJhvbVU+n2MhQMgp3TRScCBiX5tqEi4lqpKpN1kIBwyaOJmstQa0r28gKEV/NMv0qxLJH8BAjor+JTjnL4dWa4wrnDvK48zFGaLNADcCQTWCKl25kqmSfQVdJCjQTaSLepEA03zmTUGO4MOym74Od2hadyEctRKd+HW9WNRJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZft6c1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZft6c1+"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 184E7C4AF0A;
	Mon, 15 Jul 2024 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721007029;
	bh=3J8FPMqzJIfW3Jf7Y2r8LOIK9hZQF2BFPJ51MsnHNzk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OZft6c1+fNN8JDzJgXEQ4mHk9h9nk5vtr/SMNWdkZaEoO++uiE229d7OQ7UtwQFGG
	 DJ/TGt3xVE90iJR+t3CD2g2wXAC6D1PAxYtLigb+p/XDKzKbvjdAqutWIbv+WW5q/V
	 w5fB3+KX1pJ6XbJ+QoJIxJj1URSp4zKXTA+2LRj4X9eSw60Jq1UhcAYrVyRqK4OGtE
	 3GMIIo15HPwimlNffPhItaP0h76H45IJn3Nr95IqJRieQo+K5RWuuPlaMS68XvCTDz
	 UNdgl21McR6PeRLpGgCbgU5IGofz9wXOPi+JXQeY7eoP7bpQRPhkMUo+6i1wQdnGpJ
	 MQAC+mHl1Hp0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07530C43612;
	Mon, 15 Jul 2024 01:30:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bluetooth-next] Bluetooth: btmtk: Mark all stub functions
 as inline
From: patchwork-bot+bluetooth@kernel.org
Message-Id: 
 <172100702902.7085.5923916959571954245.git-patchwork-notify@kernel.org>
Date: Mon, 15 Jul 2024 01:30:29 +0000
References: <20240710-btmtk-add-missing-inline-to-stubs-v1-1-ba33143ee148@kernel.org>
In-Reply-To: <20240710-btmtk-add-missing-inline-to-stubs-v1-1-ba33143ee148@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: marcel@holtmann.org, luiz.dentz@gmail.com, sean.wang@mediatek.com,
 chris.lu@mediatek.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, linux-bluetooth@vger.kernel.org,
 linux-mediatek@lists.infradead.org, patches@lists.linux.dev

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Wed, 10 Jul 2024 10:56:24 -0700 you wrote:
> Several recent patches added static stubs to btmtk.h without the inline
> keyword, which causes instances of -Wunused-function when those stubs
> are not used anywhere in a file that includes the header:
> 
>   In file included from drivers/bluetooth/btusb.c:28:
>   drivers/bluetooth/btmtk.h:254:13: warning: 'btmtk_fw_get_filename' defined but not used [-Wunused-function]
>     254 | static void btmtk_fw_get_filename(char *buf, size_t size, u32 dev_id,
>         |             ^~~~~~~~~~~~~~~~~~~~~
>   drivers/bluetooth/btmtk.h:249:12: warning: 'btmtk_process_coredump' defined but not used [-Wunused-function]
>     249 | static int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
>         |            ^~~~~~~~~~~~~~~~~~~~~~
>   drivers/bluetooth/btmtk.h:243:12: warning: 'btmtk_register_coredump' defined but not used [-Wunused-function]
>     243 | static int btmtk_register_coredump(struct hci_dev *hdev, const char *name,
>         |            ^~~~~~~~~~~~~~~~~~~~~~~
>   drivers/bluetooth/btmtk.h:233:12: warning: 'btmtk_setup_firmware' defined but not used [-Wunused-function]
>     233 | static int btmtk_setup_firmware(struct hci_dev *hdev, const char *fwname,
>         |            ^~~~~~~~~~~~~~~~~~~~
>   drivers/bluetooth/btmtk.h:227:12: warning: 'btmtk_setup_firmware_79xx' defined but not used [-Wunused-function]
>     227 | static int btmtk_setup_firmware_79xx(struct hci_dev *hdev, const char *fwname,
>         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [bluetooth-next] Bluetooth: btmtk: Mark all stub functions as inline
    https://git.kernel.org/bluetooth/bluetooth-next/c/cebba8aa58ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


