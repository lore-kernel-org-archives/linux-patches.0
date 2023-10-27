Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D45C1A286
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 20:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="S2qtTT0r";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="S2qtTT0r";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="fr/UaC2a";
	dkim=neutral (0-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ctsCWHut";
	dkim=neutral (0-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ctsCWHut"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1701118564;
	bh=oXX78onAihDcQiKfcruuFvuUU44t2/4prTksoYcHtIA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=S2qtTT0rdzxtca78thAcLkv2yDeOceFENe0Hv0Vc37eJAhZjJqne46eWDg7/SVpAV
	 vZRa++XEY+5TJivHwmcz7IzCMd4VHgm7FLN+ZQcyoOznTQc3e5o0ERk6jLyAVW9aLt
	 FbgVt7LdJGo+JmXjiStnlwaMD0Tl07ShukrHgFPg=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 4141D1280A41
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 15:56:04 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id cBLXLMSSG96M for <patches@lists.linux.dev>;
 Mon, 27 Nov 2023 15:56:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1701118564;
	bh=oXX78onAihDcQiKfcruuFvuUU44t2/4prTksoYcHtIA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=S2qtTT0rdzxtca78thAcLkv2yDeOceFENe0Hv0Vc37eJAhZjJqne46eWDg7/SVpAV
	 vZRa++XEY+5TJivHwmcz7IzCMd4VHgm7FLN+ZQcyoOznTQc3e5o0ERk6jLyAVW9aLt
	 FbgVt7LdJGo+JmXjiStnlwaMD0Tl07ShukrHgFPg=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C8C7912808ED
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 15:56:03 -0500 (EST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1698409972;
	bh=PpcsZRP4hkvBDAQ2XBd6sP/O26p2Kk1rAGMQFr2SSuk=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=fr/UaC2as1En3mPncO54RlTPfDzGndEYkg7K3FHPK4sq+uOcG67FZETJY6gnTtcce
	 32S3QvRJOwDKB6E9vt4u0B/4rc38VWuu58NR5aqs8UwbddekYmZifMgpEiekgLnk5+
	 2hviioYl50KqK14DXwKHKdzIZtliTiboBgwfBzCU=
Received: from localhost (localhost [127.0.0.1]) by
 bedivere.hansenpartnership.com (Postfix) with ESMTP id E0E301287462 for
 <James.Bottomley@hansenpartnership.com>; Fri, 27 Oct 2023 08:32:52 -0400
 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1]) by localhost
 (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024) with
 ESMTP id gK8B-KaXFU_D for <James.Bottomley@hansenpartnership.com>; Fri, 27
 Oct 2023 08:32:52 -0400 (EDT)
Authentication-Results: bedivere.hansenpartnership.com; dkim=pass (1024-bit
 key; secure) header.d=hansenpartnership.com header.i=@hansenpartnership.com
 header.a=rsa-sha256 header.s=20151216 header.b=ctsCWHut; dkim=pass
 (1024-bit key) header.d=hansenpartnership.com
 header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216
 header.b=ctsCWHut; dkim-atps=neutral
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
 by bedivere.hansenpartnership.com (Postfix) with ESMTP id B4EDA1281D3E for
 <James.Bottomley@hansenpartnership.com>; Fri, 27 Oct 2023 08:32:52 -0400
 (EDT)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345420AbjJ0Mct (ORCPT
        <rfc822;James.Bottomley@hansenpartnership.com>);
        Fri, 27 Oct 2023 08:32:49 -0400
Received: from bedivere.hansenpartnership.com
 (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2]) by
 lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E6910A; Fri, 27 Oct
 2023 05:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1698409965;
        bh=PpcsZRP4hkvBDAQ2XBd6sP/O26p2Kk1rAGMQFr2SSuk=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=ctsCWHutHWwQ1sLy/FSZlur/NzDKdS4FhnQk91SSqlKtQpuKSSP9F3F9+ccDP3RSc
         k7wwV3FZz788xRl02meyuLwKUEaz0IYI3U4hevEob4AvQCiOtAwr+kGANU4NOZMDNa
         NjKdEh601gp/Ls5OLps9nZeX910lVnHVNQhuAIrw=
Received: from localhost (localhost [127.0.0.1]) by
 bedivere.hansenpartnership.com (Postfix) with ESMTP id 7D48A1287460; Fri,
 27 Oct 2023 08:32:45 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1]) by localhost
 (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024) with
 ESMTP id T1MDS27-eUfW; Fri, 27 Oct 2023 08:32:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1698409965;
        bh=PpcsZRP4hkvBDAQ2XBd6sP/O26p2Kk1rAGMQFr2SSuk=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=ctsCWHutHWwQ1sLy/FSZlur/NzDKdS4FhnQk91SSqlKtQpuKSSP9F3F9+ccDP3RSc
         k7wwV3FZz788xRl02meyuLwKUEaz0IYI3U4hevEob4AvQCiOtAwr+kGANU4NOZMDNa
         NjKdEh601gp/Ls5OLps9nZeX910lVnHVNQhuAIrw=
Received: from lingrow.int.hansenpartnership.com (unknown
 [IPv6:2601:5c4:4302:c21::c14]) (using TLSv1.3 with cipher
 TLS_AES_256_GCM_SHA384 (256/256 bits) key-exchange ECDHE (prime256v1)
 server-signature RSA-PSS (2048 bits)) (Client did not present a
 certificate) by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id
 A1B7E1287462; Fri, 27 Oct 2023 08:32:43 -0400 (EDT)
Message-ID: <d4157726d924a3ddad477923d6bcb4a8e6a55e60.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 4/6] tpm: Support TPM2 sized buffers (TPM2B)
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        linux-integrity@vger.kernel.org
Cc:     keyrings@vger.kernel.org,
        William Roberts <bill.c.roberts@gmail.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Julien Gomes <julien@arista.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:SECURITY SUBSYSTEM" 
        <linux-security-module@vger.kernel.org>
Date:   Fri, 27 Oct 2023 08:32:42 -0400
In-Reply-To: <20231024011531.442587-5-jarkko@kernel.org>
References: <20231024011531.442587-1-jarkko@kernel.org>
         <20231024011531.442587-5-jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Precedence: bulk
Resent-From: James Bottomley <James.Bottomley@HansenPartnership.com>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 27 Nov 2023 15:56:02 -0500
Content-Transfer-Encoding: quoted-printable
Resent-Message-Id: <20231127205604.4141D1280A41@bedivere.hansenpartnership.com>

On Tue, 2023-10-24 at 04:15 +0300, Jarkko Sakkinen wrote:
> +++ b/drivers/char/tpm/tpm-buf.c
> @@ -7,22 +7,32 @@
> =C2=A0#include <linux/tpm.h>
> =C2=A0
> =C2=A0/**
> - * tpm_buf_init() - Initialize from the heap
> + * tpm_buf_init() - Initialize a TPM buffer
> =C2=A0 * @buf:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0A @tpm_buf
> + * @sized:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Represent a sized buffer (TPM2B)
> + * @alloc:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Allocate from the heap
> =C2=A0 *
> =C2=A0 * Initialize all structure fields to zero, allocate a page from th=
e
> heap, and
> =C2=A0 * zero the bytes that the buffer headers will consume.
> =C2=A0 *
> =C2=A0 * Return: 0 or -ENOMEM
> =C2=A0 */
> -int tpm_buf_init(struct tpm_buf *buf)
> +int tpm_buf_init(struct tpm_buf *buf, bool alloc, bool sized)

I think it creates a phenomenally confusing interface to use multiple
booleans because, unlike flags, it's not self describing at point of
use.  The confusion is enormously heightened here by having the doc
book arguments be the reverse of the actual function prototype (I just
tripped over this).

The alloc flag is particularly counter intuitive: if you pass in an
allocated buffer, you expect to be responsible for freeing it again,
but that's not how you use it; you really use it like a reset not an
alloc, which looks odd because you already created a separate
tpm_buf_reset function which can't be used in this case.

Why not replace the alloc flags with two reset functions: one for TPM2B
buffers and one for command buffers?

James

