Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.99.196.166
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795300241;
	b=x6aQXw3aUzaMH3rADjo0LBX9rCNVLWtIswxJx59ExbCSPO8kzFbpyFomo5bXDwBwBZvm
	 FnPlZxvNMZeT8duDWYPPVN1lfsgjE2RA1ubY2XGva/jRdYFH0O0n6hhQ9R4QcwDNEqi2/
	 twhcgGsh2/1wBrWCubzaY5jR7BnVkAHGYIB4xGH0TaCZZtsgLkgdiognA0LN2tSZDSTFv
	 gLsPvQ+5nfIJM+oG0LRHAHz4vwXgJmBPB+fWfhDU3T1SdS/0/u0v7+jSp0PsUn482Y8jI
	 4+tDfz+Eut2583+/oknuFLS7zxIhNYgTOJQZ+JBe58AC4f8VoYpCTW3EoTMMwuMiBvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795300241;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Date:From:To:cc:
	 Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type;
	bh=JoGtzXNX8mE3lqvZL9nk/SscIkHaSe9K3EceYJcW6oU=;
	b=bNHfAUMJicDY23+aYByVzBLQI/40qzVWlE2AMMpsaFhTMOaBTrcVWW80dPvldGQAUus+
	 f1iBxWEOKUBQOKjxwFVpBRVqIyoCPomUE+45K86Q9lQTKyBAxGDS/EoUJk03pbY12ZV+Z
	 w0E9joPZHrb6BLt7IHZGhOCupf23pCQdVdGQ+LOJjAvaQBHWUu+xcMDGQwtReqflBB7MM
	 kSz7+yKdy/e0/B4xOcOYa1K8dYCLE8OPSx63beXZD/A8KxmHl61TbYcMHXUmYl612xHU2
	 8qhXjhw19bF8cOlDjmG9Govi2hHoM2qaoWjLVgLZlLU0beyB5WYDHml0Y2wHIBIzi9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=namei.org;
	spf=pass smtp.mailfrom=namei.org;
	dkim=pass header.d=namei.org header.i=@namei.org header.a=rsa-sha256 header.s=2 header.b=yo0oewSs;
	arc=none smtp.remote-ip=65.99.196.166
Received: from mail.namei.org (namei.org [65.99.196.166])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A54606A333
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 22:30:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86A54606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=namei.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=namei.org header.i=@namei.org header.a=rsa-sha256 header.s=2 header.b=yo0oewSs
Received: from localhost (localhost [127.0.0.1])
	by mail.namei.org (Postfix) with ESMTPS id 49AFE171;
	Sat, 21 Nov 2026 22:30:33 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org 49AFE171
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
	t=1795300233; bh=JoGtzXNX8mE3lqvZL9nk/SscIkHaSe9K3EceYJcW6oU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=yo0oewSsZ6gAINhCLOn50OL4sTg/O66t7BlHx0hoHfqNlKfn5+EamjZvn7hCG5ttW
	 FCkDBTTYsgS8H/+UC37gDbV/fWxCejidMv8Q1T5KShZXFTYKmO0BXtN8FkcwBbQbzU
	 XA5Fp/P8l2Zh1NWesox0aS7dq7+2aieFMrfynyak=
Date: Sat, 21 Nov 2026 14:30:33 -0800 (PST)
From: James Morris <jmorris@namei.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: stable@vger.kernel.org, patches@lists.linux.dev, 
    linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
    akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
    patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
    jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
    rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
    achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
Message-ID: <5154b570-ea6e-ef21-f0e9-cc54fc6bfc25@namei.org>
References: <20261120055248.913352689@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Tested-by: James Morris <jmorris@namei.org>

Assisted by an LLM.

Stock 7.3.6-rc2 (d6a022cc5dc8) boots on a SpacemiT K3 CoM260 IFX 
(riscv64). U-Boot loaded the kernel, DTB and initramfs from NVMe; Linux 
ran from RAM with clk_ignore_unused.

DLDO4 stayed enabled at 1.8 V after unused-regulator cleanup. All eight 
harts came online, timer interrupts advanced, and the supervisor IMSIC and 
KVM initialized. With QEMU 10.2.2, KVM guests on the PLIC booted and shut 
down with 1, 2 and 8 vCPUs, and the virtio block and network guests 
passed. I saw no lockups, RCU stalls, oopses or panics.

One problem: dtbs_check now warns on all three K3 DTBs. 7.3.5 is clean.

  /soc/interrupt-controller@f1810000: failed to match any schema with 
compatible: ['spacemit,k3-aclint-mswi']
  /soc/timer@f1814000: failed to match any schema with compatible: 
['spacemit,k3-aclint-mtimer']
  /soc/interrupt-controller@f181c000: failed to match any schema with 
compatible: ['spacemit,k3-aclint-sswi']

The queue has two patches from Junhui Liu's ACLINT series:

  5397ba147c28 ("dt-bindings: timer: sifive,clint: Remove 
spacemit,k3-clint")
  cc6371a7f519 ("riscv: dts: spacemit: k3: Replace incorrect CLINT node 
with ACLINT nodes")

It does not have the three that add the new compatibles:

  73329198cdc2 ("dt-bindings: timer: thead,c900-aclint-mtimer: Add 
SpacemiT K3")
  c9bae665035f ("dt-bindings: interrupt-controller: 
thead,c900-aclint-mswi: Add SpacemiT K3")
  08257b5b3d38 ("dt-bindings: interrupt-controller: 
thead,c900-aclint-sswi: Add SpacemiT K3")

Those three apply cleanly to 7.3.6-rc2, and the check is clean with
them. I saw no runtime effect.


-- 
James Morris
<jmorris@namei.org>

