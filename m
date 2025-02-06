Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C59207E0E
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 09:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738832427; cv=none; b=L4SF/48XKGUdzhhvXugdxylwr6/ECck58rQXp0gsJ3xdBjlpIFs//ZTfaZ+A+S7GyH9qOBnNixb/hsqcjWoAIYg7SYbaAdXeMMdUtwfqKpEG8gSclHQEPf9tbw0dvDo29Tew11K+r5F+nKgacksZnLfZRMohRbI5h5Fvv8zrCPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738832427; c=relaxed/simple;
	bh=fP8lW/xe9f4DET2rvmmufyFEjRPrSmq+iN1o+9ZWvR4=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CoiCykuazmiGRSLe8wGCaHeqH3c5iqlXVjmpueJtjh0J5Uk4vhLdDnPly5iSdioyjiAYvpdblnRA6r5YPB7Y8qaOgLVvf1h7+tifmGb4au3Gztd1MPDrPq+PyyimZC3V7TC3rYSpRWIhZCdVBT7eFy07PDD0lMdXku1ODxcD+fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dWLS24n+; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dWLS24n+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738832426; x=1770368426;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=fP8lW/xe9f4DET2rvmmufyFEjRPrSmq+iN1o+9ZWvR4=;
  b=dWLS24n+O/FP8NIeAuui+fAh2sbUJM9ClxC7q72KqgoJ7FLQ02cNogaK
   7JGoLaUHyXo/U+QHj5s8IH12H3X6OEmoV+IF3tRnWpLS8aq1MwAxX/zKd
   ASS1tljRcLxxCCKRJYvVe2jilwaeaMtvX6pnuVP9DnmE9ZVQc2WSsm28C
   REMiZ19My9libMfH4kE180ma+ImcP4IrzyQ3WB9livQGSmjpqzEYxz86S
   4nmtCXl9iUEM4pgKfseQV8OHTRPQASdhuR6FhoU2efMkK5ymSTSBVeRNs
   LjmZlWOl6ovRVkuoHqbXvYshY3xQ3GxhGnH4TaAquvNi3/PfoAmaJ7PTN
   A==;
X-CSE-ConnectionGUID: 9dlF+pZFTHWfQasjgMJ+6Q==
X-CSE-MsgGUID: aJmzDWGpRQ+L+5rxW5rl0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="38655033"
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="38655033"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 01:00:25 -0800
X-CSE-ConnectionGUID: ZoQNWTg2TCKt1ZQwWCHJFQ==
X-CSE-MsgGUID: 5g9lTXqJS2uvL+z3QAdcpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="134381887"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.165])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 01:00:22 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 6 Feb 2025 11:00:18 +0200 (EET)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
    Sasha Levin <sashal@kernel.org>
cc: stable@vger.kernel.org, patches@lists.linux.dev, 
    Jian-Hong Pan <jhp@endlessos.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 6.13 445/623] PCI/ASPM: Save parent L1SS config in
 pci_save_aspm_l1ss_state()
In-Reply-To: <20250205134513.241757556@linuxfoundation.org>
Message-ID: <7a41907d-14d0-a1a4-47d6-90ff572d5af9@linux.intel.com>
References: <20250205134456.221272033@linuxfoundation.org> <20250205134513.241757556@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-293007893-1738832330=:931"
Content-ID: <05fc6404-da1f-0bd9-994c-69166039b704@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-293007893-1738832330=:931
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <818d9580-e5c2-dade-c632-f4837610f77b@linux.intel.com>

On Wed, 5 Feb 2025, Greg Kroah-Hartman wrote:

> 6.13-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Jian-Hong Pan <jhp@endlessos.org>
>=20
> [ Upstream commit 1db806ec06b7c6e08e8af57088da067963ddf117 ]
>=20
> After 17423360a27a ("PCI/ASPM: Save L1 PM Substates Capability for
> suspend/resume"), pci_save_aspm_l1ss_state(dev) saves the L1SS state for
> "dev", and pci_restore_aspm_l1ss_state(dev) restores the state for both
> "dev" and its parent.
>=20
> The problem is that unless pci_save_state() has been used in some other
> path and has already saved the parent L1SS state, we will restore junk to
> the parent, which means the L1 Substates likely won't work correctly.
>=20
> Save the L1SS config for both the device and its parent in
> pci_save_aspm_l1ss_state().  When restoring, we need both because L1SS mu=
st
> be enabled at the parent (the Downstream Port) before being enabled at th=
e
> child (the Upstream Port).
>=20
> Link: https://lore.kernel.org/r/20241115072200.37509-3-jhp@endlessos.org
> Fixes: 17423360a27a ("PCI/ASPM: Save L1 PM Substates Capability for suspe=
nd/resume")
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D218394
> Suggested-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
> [bhelgaas: parallel save/restore structure, simplify commit log, patch at
> https://lore.kernel.org/r/20241212230340.GA3267194@bhelgaas]
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Tested-by: Jian-Hong Pan <jhp@endlessos.org> # Asus B1400CEAE
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi stable maintainers,

Please withhold this commit from stable until its fix ("PCI/ASPM: Fix L1SS=
=20
saving") can be pushed at the same as having this commit alone can causes=
=20
PCIe devices to becomes unavailable and hang the system during PM=20
transitions.

The fix is currently in pci/for-linus as the commit c312f005dedc, but=20
Bjorn might add more reported-by/tested-by tags if more people hit it=20
before the commit makes into Linus' tree so don't expect that commit id to=
=20
be stable just yet.

--=20
 i.

> ---
>  drivers/pci/pcie/aspm.c | 33 ++++++++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 28567d457613b..e0bc90597dcad 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -81,24 +81,47 @@ void pci_configure_aspm_l1ss(struct pci_dev *pdev)
> =20
>  void pci_save_aspm_l1ss_state(struct pci_dev *pdev)
>  {
> +=09struct pci_dev *parent =3D pdev->bus->self;
>  =09struct pci_cap_saved_state *save_state;
> -=09u16 l1ss =3D pdev->l1ss;
>  =09u32 *cap;
> =20
> +=09/*
> +=09 * If this is a Downstream Port, we never restore the L1SS state
> +=09 * directly; we only restore it when we restore the state of the
> +=09 * Upstream Port below it.
> +=09 */
> +=09if (pcie_downstream_port(pdev) || !parent)
> +=09=09return;
> +
> +=09if (!pdev->l1ss || !parent->l1ss)
> +=09=09return;
> +
>  =09/*
>  =09 * Save L1 substate configuration. The ASPM L0s/L1 configuration
>  =09 * in PCI_EXP_LNKCTL_ASPMC is saved by pci_save_pcie_state().
>  =09 */
> -=09if (!l1ss)
> +=09save_state =3D pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_L1SS);
> +=09if (!save_state)
>  =09=09return;
> =20
> -=09save_state =3D pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_L1SS);
> +=09cap =3D &save_state->cap.data[0];
> +=09pci_read_config_dword(pdev, pdev->l1ss + PCI_L1SS_CTL2, cap++);
> +=09pci_read_config_dword(pdev, pdev->l1ss + PCI_L1SS_CTL1, cap++);
> +
> +=09if (parent->state_saved)
> +=09=09return;
> +
> +=09/*
> +=09 * Save parent's L1 substate configuration so we have it for
> +=09 * pci_restore_aspm_l1ss_state(pdev) to restore.
> +=09 */
> +=09save_state =3D pci_find_saved_ext_cap(parent, PCI_EXT_CAP_ID_L1SS);
>  =09if (!save_state)
>  =09=09return;
> =20
>  =09cap =3D &save_state->cap.data[0];
> -=09pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL2, cap++);
> -=09pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL1, cap++);
> +=09pci_read_config_dword(parent, parent->l1ss + PCI_L1SS_CTL2, cap++);
> +=09pci_read_config_dword(parent, parent->l1ss + PCI_L1SS_CTL1, cap++);
>  }
> =20
>  void pci_restore_aspm_l1ss_state(struct pci_dev *pdev)
>=20
--8323328-293007893-1738832330=:931--
