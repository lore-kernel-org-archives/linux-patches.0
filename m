Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA0C20322
	for <patches@lists.linux.dev>; Thu, 16 Oct 2025 01:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760576845; cv=none; b=C6noU8+mJUbT1582Mgo7na4hjH/JUmSJU1+ZMm89RptcksTG2wyj8IrYlTERMZxdhOnkAqI4Q6ufhSVmYiPss4dwCRgA42BlX1hwr3tNCEH02EkZ85jmvowiTplz155jUalm6uz0wjKikUBMelQaTrI+OgowVBSvtI1po3cKtik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760576845; c=relaxed/simple;
	bh=O4OZ5zIw9Ismrn7MxvCmAGvHrebYJ6k+N8af+7iUGGk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rEh3AFe14KaFNjKauCFuknR3Pq61QtIdcJP1WJs14833Wh+i/vnuLJGTg/vJtMaleKsFAnHMNdC1yd20zq6pzgowMUAjffKnKaM9oriFRSOmt5ShH3gaDySI7SDcsRX7CGeLHOHLlqi+PEEWMa3w3DtKO8yGDlKjnbXx24kC5gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b=LW+ETCKC; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b="LW+ETCKC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1760576836; x=1761181636; i=s.l-h@gmx.de;
	bh=G2tTVPVg6iCv2uxTz3eVWui1dL59bg4p44QWdjUcS3c=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=LW+ETCKCmUuTxq/nSL9I/ner6Z6A00HvXPdpKynFcsQ/8yJq5q+jRaO62gmzp1sa
	 Rutot2GYW0OAoTodVZCjvBvkHfdBUKrLB8KBgx5AW3lyXoZbIBGSJmJE7+6KGqpUq
	 yPY+EIrkA3xSoSzSqG7XBjRSg9CO8meyYMizvBzyK4HTDa3RZSW8mW5DOUVajlCZN
	 fT8hMKErY8DWvaXcVeyH3aIqdB2PS+yfraPmaiF3xw72SUby61NVQrFYYTdzEKVVy
	 Xgbi0lh+eRNqWTZRtG0fa7aGpI6e0ysDITrh2B10f9kpo6y5OGchKGw+UzskWVJ6b
	 73RgliSmusVTsr1Szg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mir ([94.31.111.154]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N2mBQ-1uD0mG0xrg-00w7k8; Thu, 16
 Oct 2025 03:07:16 +0200
Date: Thu, 16 Oct 2025 03:07:11 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>, Inochi
 Amaoto <inochiama@gmail.com>, Chen Wang <unicorn_wang@outlook.com>, Bjorn
 Helgaas <bhelgaas@google.com>, Sasha Levin <sashal@kernel.org>, Kenneth
 Crudup <kenny@panix.com>, Genes Lists <lists@sapience.com>, Jens Axboe
 <axboe@kernel.dk>, Todd Brandt <todd.e.brandt@intel.com>, Stefan
 Lippers-Hollmann <s.l-h@gmx.de>
Subject: Re: [PATCH 6.17 068/563] PCI/MSI: Add startup/shutdown for per
 device domains
Message-ID: <20251016030711.57e92e97@mir>
In-Reply-To: <20251013211648.GA864848@bhelgaas>
References: <20251013144413.753811471@linuxfoundation.org>
	<20251013211648.GA864848@bhelgaas>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:O3hqQhU0r+mPy8f3XGvnSNAgAPR64b83FrqI6SsWN5rRenBLeS9
 tOjYDHIqdst8ylaLCBeMexwwPIn6Auj6dAOc/w+CziG5RrNIT6KB7H7I7I/z6zDQC7I49nX
 uNJtLQgpfICcV+AgcdBeaHcSiw9+5kJV2JVYVmbrdiEojae1LfG1/1nQ+NqAFnsG8KsZb0v
 dllLRzw/q0854SJpHfqVw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:LWpJWoiKPH8=;VllLGipIlvwRWhItIaKsxOdI7MO
 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
 hLX/g==

Hi

On 2025-10-13, Bjorn Helgaas wrote:
> [+cc Kenny, Gene, Jens, Todd]
>=20
> On Mon, Oct 13, 2025 at 04:38:49PM +0200, Greg Kroah-Hartman wrote:
> > 6.17-stable review patch.  If anyone has any objections, please let me=
 know.
>=20
> We have open regression reports about this, so I don't think we
> should backport it yet:
>=20
>   https://lore.kernel.org/r/af5f1790-c3b3-4f43-97d5-759d43e09c7b@panix.c=
om

I've received a similar report for v6.17.3-rc1/ v6.17.3 (v6.17.2 was=20
fine) on a Lenovo 82FG/ Ideapad 5-15ITL05 (i5-1135G7 and Xe graphics),=20
failing to (UEFI-) boot already within the initramfs (Debian/ unstable,=20
initramfs-tools).

Backing out (only) the changes to drivers/pci/msi/irqdomain.c and=20
include/linux/msi.h from patch-6.17.3 fixes the regression again.

Regards
	Stefan Lippers-Hollmann
