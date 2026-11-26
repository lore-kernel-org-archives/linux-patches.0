Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795676706;
	b=CfTN8UAlyYOHCrv5bfYHWADthp+vKvgHjZwdq/y2muBjrdgomOhIBE5eV8sIp1fqGWFf
	 KCJj7+20Qemgz5Eo3CerCChBlIDT8Ok/gebZcOi9T1yww0plEkzB4cXVWe1cx548P+B9A
	 WqYmstHYpWwSEKBXGrH621N9Vp3Q+GlZIGoyQ1sL186DYI4syhiPlXzR8/0aAiywGouAg
	 P0Nq9rQdReTaATSFn/NJGgFVNlg1tatCEY13m+o3QKlbq2M4ucN4mFG4S9QmGXUWl/31a
	 YuqX2YT7ZAGtB+Ms0jKLl7jLk3ybLaHCjOJnlVWSr9TRLrczfMupAEbDQC171WpyVsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676706;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=cp/ltoC04vlPWpyVW0AoQORCWHUFFV9YG64MDzRXtWw=;
	b=hDF0t/4UZ2WLVzWfvRT5+PI3YSJUTVZbg6GenBXAFDN2aEZFwWI4e5NtIaRcNRv5Xjb/
	 xOlBB/W3khKExB8lOiaRoCCXIkTsjC42QSbnzLzl8xSOaBJYDoLlJa2ketDTyubULzL+B
	 lKL2Qg9EH684JO+RYJRPhhk60ZGbWqXMf9noh68d6lrWMqosjBfZjsrsWoPek5vyD0VXd
	 7LMnI3u+UPOIolE8adPGYmtv8v9udcdU06E5O4p+/qL/qqQKyDw8jXvAOd/zT9puDuqWG
	 OBBBJmBWVnjFqnzaLM3LfLdeXh4G4HoFpdzhJQTNtRXI2N2GgXTrUVUtspERkVrpsPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Qa+/Y9Ow";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF5E606A31C;
	Thu, 26 Nov 2026 07:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qa+/Y9Ow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065411F000C4;
	Thu, 26 Nov 2026 07:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795676706;
	bh=cp/ltoC04vlPWpyVW0AoQORCWHUFFV9YG64MDzRXtWw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Qa+/Y9Ow7w/8qe+BKzl555ztoRKlew8zwz9huXh+ArssV9RMTS4fGtjSwNKrC4jYB
	 G4fbNW0PxqYSuQxMxMWri3XIz7XdB+FFId2BrwObD4Z0Z+qAo9z2EWOHEIFQ5tn4V1
	 2ZNm4Abr5aQDIHQYawUsQVUbjZXZ4zGQ3E7QZaoxcaj9zLhlM8zdC3AdqNN6y/5ynm
	 R5gpGYjbRUP98cb0fGij5zgbl4rivcGfO8Jvi38svkIfPg1Zfd9AiDhxT24MBhYgAt
	 ieACDhEwXSfkXO3H+yMXQNmydnOQsALL9saHFci4mOPP0Yt9HyKx/A9V73dRbEaku6
	 QKi0MPqaQQ/Rw==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alexey Kardashevskiy <aik@amd.com>, linux-coco@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 04/10] PCI/TSM: Defer TSM vDEVICE allocation until
 device setup completes
In-Reply-To: <20261125141947.GD246011@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-5-aneesh.kumar@kernel.org>
 <5e04323f-dfdc-4956-acee-bcc09926726d@amd.com>
 <yq5aqzg99uio.fsf@kernel.org> <20261125141947.GD246011@ziepe.ca>
Date: Thu, 26 Nov 2026 12:34:57 +0530
Message-ID: <yq5ald6gul7q.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Wed, Nov 25, 2026 at 02:07:19PM +0530, Aneesh Kumar K.V wrote:
>
>> That is what this patch does. If IDE setup is not complete but the
>> device already has tsm0 attached and connected, pci_tsm_context_get()
>> returns an error from cca_vdevice_init(), preventing the device from
>> being assigned to the VM.
>
> If the device has not been fully accepted on the SPDM side then you
> should not be able to create an iommufd vdevice for it, nothing else.


That is what this patch does.

-aneesh
