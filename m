Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794836055;
	b=MPtqbXWmB7trwa62txNo3PvH8ae9Nl/xxGxkm1Y+aIUUkRfgph4EWMnUDwmjDLYNkcqm
	 TG9ED47laFXTbOx/JqgyLJ/Ruz4xMIl97M9eqYTI+UApN9cGlHDgUquckHj9OZjCPFaeH
	 cET9KUqQsyP5PxdD8fVzzMosQuap9f6W1QuNbyvAaG2T/9DIerLaNwJAOiclTkGRohYQ8
	 JphAQRwlffJC6l7jni94jrHL9FYPCx/j5og7mKBEK5K6gnxvVBqQxYKkpzE1pWksbbXOg
	 U2RqtduSB5uwZfh0slF5onnq1UafluzEe3Z4Sau9fndUqwOxGimS0qcQdKi6F4uETDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794836055;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=kFki2hBsnHrC0juVnTO+KTiVDm5TzD8rtd8Do1S8nSI=;
	b=AXealKWI29foF+NPl0fll2Z3GqgEGeDZFb57UxHsbrLUrqlqkE3Douvxey2sMTlej49U
	 HkiX7xdfNOYTMeY3NBE7nlCarr/9fsu6WcJEC5G51QOJvlK34w92TfkhRB8alTtMVsMjz
	 qQdSjZx5TVlu88wlmnEMQOlDaYtTTnJhgQSE0IF96ZCenDrj1Xpg7BEAMw+phyGRVtCJ1
	 2DjyjrQ7Ueie5HrMo96/lyUIzWCHTse+YmuTGRcVQtJ0mJQHVbxuX3SWDy/uLk8OVQqrq
	 hTzJCMuW1DO0oJqWgTos/vBZ/BdshKMlQsAulf7b7TkaTIDPJcXfUNPKk+JjJE1wtKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cVjD1IIy;
	arc=none smtp.remote-ip=91.218.175.104
Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27305606A323
	for <patches@lists.linux.dev>; Mon, 16 Nov 2026 13:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27305606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cVjD1IIy
X-Envelope-To: patches@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kFki2hBsnHrC0juVnTO+KTiVDm5TzD8rtd8Do1S8nSI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794836053; v=1; x=1795440853;
 b=cVjD1IIyjvB3aeptttsmfmPZky+MtqINq24PqHtlxmox00kfdTfv5yl2cCXlBxJrPyWSfYea
 Jsr+TaIOrLPOdDhKzwi3ow9GFAoXUpW84HAcfl/KlFLJfFwQA5UcNs340C/oZBVESo8N2UYG5J1
 j9+BGuax2ZJYGWybXbamWdDM=
X-Envelope-To: patches@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 62b6bbe6cd2196e6;
	Mon, 16 Nov 2026 13:34:13 +0000
X-Mizu-Trace-ID: 62b6bbe6cd2196e6
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so10052e87.0
        for <patches@lists.linux.dev>; Mon, 16 Nov 2026 05:34:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEdmqGZzbqIZZTKYdCG/u7vC0kg3EUdHNV7B5Cc0cfX5i0aTOv0bDd4liksNo0xavgZLCRr8mZn@lists.linux.dev
X-Gm-Message-State: APuU4Z8aXNpzAnfMeYw47f/vo2PZoTLB4Jkr62tJdhBgyGMPzpNsvbu+
	unnt/1zugNgPFCPyVD6JhniAaPOOpRO3uJM8QmUzKsJPEFmjxmHuEg0VzrJhwZM5H611qzd0Ats
	qLYny1bFKneJxRGapfvkK9irF/+uM+TwrPX4xGv12
X-Received: by 2002:a05:6512:3087:b0:5bf:b994:6598 with SMTP id
 2adb3069b0e04-5c17d98271emr226475e87.6.1794836047954; Mon, 16 Nov 2026
 05:34:07 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116091137.94252-1-aneesh.kumar@kernel.org> <20261116091137.94252-3-aneesh.kumar@kernel.org>
In-Reply-To: <20261116091137.94252-3-aneesh.kumar@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 16 Nov 2026 13:33:31 +0000
X-Gmail-Original-Message-ID: <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
X-Gm-Features: AclHuK93q6K13zN84KswjEKi9cVQgC-Cy80dn3a2peCMzM1qEee3TapGEGzaKvg
Message-ID: <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
Subject: Re: [PATCH v10 02/13] mm: Zero memory during shared memory transitions
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Steven Price <steven.price@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>, 
	"T.J. Mercier" <tjmercier@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, dri-devel@lists.freedesktop.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Aneesh,

On Mon, 16 Nov 2026 at 09:12, Aneesh Kumar K.V (Arm)
<aneesh.kumar@kernel.org> wrote:
[...]
> Keep allocations on platforms without memory encryption on the ordinary page
> allocator path so the original GFP constraints, including __GFP_ZERO, remain
> intact. Remove post-transition memset() calls that are now redundant and
> explicitly clear allocations on paths where no transition occurs.
>
> This intentionally makes every private-to-shared transition destructive;
> callers can no longer use set_memory_decrypted() to preserve existing contents.

pKVM shares memory in place, and a guest has to be able to share
memory it has already set up, as Vincent pointed out [1]. That was one
of the primary reasons for in-place conversion in guest_memfd.

Cheers,
/fuad

[1] https://lore.kernel.org/all/avro44jUWOARFzul@google.com/
