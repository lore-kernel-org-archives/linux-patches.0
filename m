Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB8033ADB9;
	Sun, 31 May 2026 19:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780257577; cv=none; b=lVamdMBcZH6OpRmCkYdg9rgnBjygwEka+Lwqk1SjXnJdpsQbM8afmGQOxeqQ4c7f6ljS91+quRbYzq88jUgM454Wa/VfkG2XlpReXsbb9497dqIbgiZfyarnfNmGqDRWkn7fk3tfpvL/dgXuF4qkACHzPrzcD7M3H+A1CxiQY1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780257577; c=relaxed/simple;
	bh=k106Z2KaX+ljDvwcW+GCOwU/FBMLDiohQoo3OZNmhfI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S2B6SAFwYcnW0yrUV5iovAZQq66Al2rGgfi5DufImx4KQf05SQw0NpM6uDslfITLoxNt42WyCLA2HpajDtyDyOkliILvfQ79W5dHhQpQTIM8MpYgGn0P6m8WBIh0evlPcB5wmN24mDcuiQ4LS/JsBVfgWDURWTkRJkh4ZeLSx44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTmJi-000Pd2-2x;
	Sun, 31 May 2026 19:59:26 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTmJi-0000000FQk4-0frN;
	Sun, 31 May 2026 21:59:26 +0200
Message-ID: <203134947f42d331eeb0f19c0849802c044103c7.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 176/589] KVM: nSVM: Mark all of vmcb02 dirty when
 restoring nested state
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yosry Ahmed <yosry.ahmed@linux.dev>, Sean
 Christopherson <seanjc@google.com>
Date: Sun, 31 May 2026 21:59:21 +0200
In-Reply-To: <20260530160229.512180199@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160229.512180199@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-O9XXhZybCtgtX9mSZOUw"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-O9XXhZybCtgtX9mSZOUw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 18:00 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
>=20
> commit e63fb1379f4b9300a44739964e69549bebbcdca4 upstream.
>=20
> When restoring a vCPU in guest mode, any state restored before
> KVM_SET_NESTED_STATE (e.g. KVM_SET_SREGS) will mark the corresponding
> dirty bits in vmcb01, as it is the active VMCB before switching to
> vmcb02 in svm_set_nested_state().

Given thow much svm_set_nested_state() has changed since 5.10, I'm
having a hard time seeing how this fix can work here, particularly
without commit 4995a3685f1b "KVM: SVM: Use a separate vmcb for the
nested L2 guest".  Has this been tested on 5.10?

Ben.

>=20
> Hence, mark all fields in vmcb02 dirty in svm_set_nested_state() to
> capture any previously restored fields.
>=20
> Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_S=
ET_NESTED_STATE")
> CC: stable@vger.kernel.org
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Link: https://patch.msgid.link/20260210010806.3204289-1-yosry.ahmed@linux=
.dev
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kvm/svm/nested.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1236,6 +1236,12 @@ static int svm_set_nested_state(struct k
>  		goto out_free;
> =20
>  	/*
> +	 * Any previously restored state (e.g. KVM_SET_SREGS) would mark fields
> +	 * dirty in vmcb01 instead of vmcb02, so mark all of vmcb02 dirty here.
> +	 */
> +	vmcb_mark_all_dirty(svm->vmcb);
> +
> +	/*
>  	 * All checks done, we can enter guest mode.  L1 control fields
>  	 * come from the nested save state.  Guest state is already
>  	 * in the registers, the save area of the nested state instead
>=20
>=20

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.

--=-O9XXhZybCtgtX9mSZOUw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmockxkACgkQ57/I7JWG
EQnmPhAAzp5n8oNeNlzyNIGQQVR6KEX2mcNdvM42nESS/2DJWEiMrcGBw+ISEpj0
S0N31KVk6U6aVREtdJvqNGYaqQOfY7ofEyl7w81eqOIa7hNFTEWfFxzCtHJWBwOB
jZTcJaap9Sd+9v0DsMToN0eRR3379TDThXRzbQoj6xMb02FoxumZIy9BL91tkI0g
Q+xvwH64aHt6EffhxU92/FBotsYVqBo0wEa5c9s+mVp/bakglbeSFF9tjusQUtyQ
G+7kPjxFVkormcp35B/GxQp9syHUmqw08xwtMgv3oSx0hTAi+GP9a69a16d6VZhc
0azcwGnFIqJkUAu7ujXfmxiIe7Yb0eLurj0WC7GL1gzUQyAfFlwSa2OUf7LRPUtC
k5Dqcm28sQHd0ypVsEdNXqw1iUVLbmG9/gV2Ozf4DErPYRT24KiQLE1ahOboXZWW
F0N/gnNWwRFi4jcu5sA9YhjlUynlOZGvqNQ9VyAM/bR/xxQYJbJSjGqX8dt7NPP2
AcbXwdMZEC+hmpuAtEtUmemO/oMTVuGHI+WQlpKBR1qXPQAFUy2tPYdwtZdqwWts
dbX6bY5idTOmhEyBnsSqgS2ViW74wVy0zJPMO3bDIgDBNoQN5hE/FPx74Cb7u9y9
rf5BwzxSpW7me1C3puQwNR8YTFuwfeGS+4pM9BMSLBgCxMIFwFg=
=BzDy
-----END PGP SIGNATURE-----

--=-O9XXhZybCtgtX9mSZOUw--
