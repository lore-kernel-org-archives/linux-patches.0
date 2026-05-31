Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7840130148A
	for <patches@lists.linux.dev>; Sun, 31 May 2026 22:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780266786; cv=none; b=mSDf0gj7ksWY6cMCNelPK4oYYRtRdgdQAN6lRCAVZ+JC6ZdQoilbEQ3Q+lRCiPsmsdbZRzLnCnaPpp6d+M2Xxu+9Kk7JS//neloD8dZ3DhG5k8LvpJg9EM8mLJC0OMFWXJO7GOjA/i/k+4Rne1VokM59Kh3MNuCuhFVxDMU6V8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780266786; c=relaxed/simple;
	bh=R0S6ndC5Ri+Wndh5doVmrm6kTANEa5CDsZsBjFi+u8Q=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=snj9Qxsi9erVsN4EODSvhg79kaeNU2uVIys/77FQW1xeTEULVynWQ8IuG/rZvVwwPRbLS3TPPffh4TaA+591JNVsgCGaNW7ZxI/esIUrKY7khB/jJqnyDpg1swHqLh2JtBzUxuP8m8Ytk0KrEHfWQvARe91p35xJoz7yw7ipFs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o4tgIZ/0; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o4tgIZ/0"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-304d8e3bb72so4629190eec.1
        for <patches@lists.linux.dev>; Sun, 31 May 2026 15:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780266784; x=1780871584; darn=lists.linux.dev;
        h=in-reply-to:content-language:references:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cgzwm13HnnSC1Y4klYORe79NPgyF+qJNTa3oDX+gZEM=;
        b=o4tgIZ/0mD/pKZdTWOObKjJ9IoPY+qwqyIZAccGuti7ieYSflMHb+dQFNddRYE4dbe
         SAE+O1jtI5I4vCVtyczSuG2GwMc9ZEHxydoMkUS+4ox7IOf/3fs76a+g1Ui6OZdAr9j/
         CFozR8a972E9G+tsIFQKbd+iMoYJV5Uop3Y2G2xfGtotRVywJVtt7yXSbulUBOwWej47
         SH28vA6ANcvK2wyZHAlOYAi2Ma/hzJ5qEf3Az/2Nz4Du7qVnkQJNmNy2BcHfb42A57i6
         CkJFkiu7CwZ3BC8rN2Yzoc2tO6VEDIAdlkFDxRS7RHGWqPPqNxmNxxLJLZ2HG4GBptNn
         t33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780266784; x=1780871584;
        h=in-reply-to:content-language:references:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cgzwm13HnnSC1Y4klYORe79NPgyF+qJNTa3oDX+gZEM=;
        b=E3UVr7TVV4RyY0ECifM+3KtqEJzk699tbeHYyuPJFzzzadfjuzhIIdXjExD2GfHumu
         Ndw8M2DZnlYCxSw2MHC2cx+nFrJZ8vjjQD143+jQ1qpOvFUXa6tl/lzWavFyS6rvbaGM
         2NxVsJZ3BukY4OKi2Aal1G6PPCXT9+KVAoSxSga90q7vd9gI+nFOkI8BewyuxvyayR6V
         gZCxh+fXT8dMQ02JXHRDEM2n5yWmguiMpj7zMAqLHh08Zl+wzgfc/fcYnWD3rH4WHoRt
         ysqK+aRkYDGnvTl3xeGZB8/5fKH8eRAYnKJ8Xghxl/XZtEYNf7rIydKCRqNQ1a9Cy+NL
         DQqQ==
X-Gm-Message-State: AOJu0Yz0QubImwsJMXIPdJ/8hYOMWnVCyE8WXf8rKIFrrbkrArYB3lUD
	UxdAWdiba0nkYjy3mfj4t+iGQG96yVvKM14yvbbloWMjvHcTj8ODdQLm
X-Gm-Gg: Acq92OHrsLwZOkoIRr2xeDG/PiAIkJgd7OrggaeJ9l5cw7JzmsAqCMTykzRDTzideYP
	Icj/wAViBVzU370oqlshhJO6w5qUaOtZKa/Y39cCWCYnmt9sJJHjA0wIbn0rWKKXOpsz+UH1EGU
	UcDahFMJPd2Zzyf+KN1vCUExQS6XsZxwdKppoPlcTdTU27JsKkZ5gcN0ZfrLWUavEbwUf2QjUxt
	p5EzZ7vqSZXEYTzRGm7/plzsejD/3KX1nJE2oKaWvsEAstYWgh5MjU5dYRmrxYPuTi/WIE0VbsW
	EYK//FFxOlE5KYoqfzF0ObOVL5DdUAL38bzqE6jCNRZQ+SzjpRoQ4SI/EheUMabglDc8KYh74Yv
	krvuhOQC7PyVSNVGUHqduyCXXXPRpgGUjHP8T/Gwtn1Ydrn1S9a4CeITDmJ57hmaepp8YSkCaew
	vAOUKztQuEsd4sROmCELjTs/NUnxRtOSJDC/K/uWqSlzu4mK1D8rr4us8xlClwV88eOzo3UWIi+
	DZ5msFmAkoM
X-Received: by 2002:a05:7301:2926:b0:304:d456:fca4 with SMTP id 5a478bee46e88-304fa67e7acmr3850002eec.21.1780266784340;
        Sun, 31 May 2026 15:33:04 -0700 (PDT)
Received: from [192.168.1.18] (177-4-161-23.user3p.v-tal.net.br. [177.4.161.23])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ed5b8fbbsm7355002eec.26.2026.05.31.15.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2026 15:33:03 -0700 (PDT)
Message-ID: <a6df0003-8be0-4663-8753-4e28f4cffb1e@gmail.com>
Date: Sun, 31 May 2026 19:32:58 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?C=C3=A1ssio_Gabriel_Monteiro_Pires?=
 <cassiogabrielcontato@gmail.com>
Subject: Re: [PATCH 5.10 002/589] ASoC: SOF: topology: reject invalid vendor
 array size in token parser
To: Ben Hutchings <ben@decadent.org.uk>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Mark Brown <broonie@kernel.org>
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20260530160224.570625122@linuxfoundation.org>
 <20260530160224.642881938@linuxfoundation.org>
 <daa0df3788560bd8759418d9c333e09c45368aa4.camel@decadent.org.uk>
Content-Language: en-US
In-Reply-To: <daa0df3788560bd8759418d9c333e09c45368aa4.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------mSZlpNXjrCJz0CATVO2tiEZ9"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------mSZlpNXjrCJz0CATVO2tiEZ9
Content-Type: multipart/mixed; boundary="------------1hYVgRe97fvA93KIF4BIXAZE";
 protected-headers="v1"
From: =?UTF-8?Q?C=C3=A1ssio_Gabriel_Monteiro_Pires?=
 <cassiogabrielcontato@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Mark Brown <broonie@kernel.org>
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Message-ID: <a6df0003-8be0-4663-8753-4e28f4cffb1e@gmail.com>
Subject: Re: [PATCH 5.10 002/589] ASoC: SOF: topology: reject invalid vendor
 array size in token parser
References: <20260530160224.570625122@linuxfoundation.org>
 <20260530160224.642881938@linuxfoundation.org>
 <daa0df3788560bd8759418d9c333e09c45368aa4.camel@decadent.org.uk>
In-Reply-To: <daa0df3788560bd8759418d9c333e09c45368aa4.camel@decadent.org.uk>
Autocrypt-Gossip: addr=broonie@kernel.org; keydata=
 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

--------------1hYVgRe97fvA93KIF4BIXAZE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi!

On 5/30/26 15:51, Ben Hutchings wrote:
> On Sat, 2026-05-30 at 17:58 +0200, Greg Kroah-Hartman wrote:
>> 5.10-stable review patch.  If anyone has any objections, please let me=
 know.

>>  		/* validate asize */
>> -		if (asize < 0) { /* FIXME: A zero-size array makes no sense */
>> +		if (asize < sizeof(*array)) {
>=20
> asize is signed and this=C2=A0comparison coerces it to be unsigned.  So=
 non-
> negative values of asize that are too small will be correctly rejected
> here, but negative values will now be accepted.
>=20
> I think this creates a worse security problem than it solves.

Thanks for catching this.

In order to keep the minimum header-size validation but force the compari=
son
to remain signed, I think we can do this:

        if (asize < (int)sizeof(*array))

While checking this further, I also noticed a separate parser-hardening i=
ssue:
sof_parse_token_sets() reads array->size before checking that the remaini=
ng
private data contains a full struct snd_soc_tplg_vendor_array header.

So, on top of the signed comparison fix, the safer ordering would be:

--->8

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index cc6806cf59cd..bb6b981e55d1 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -740,6 +740,9 @@ static int sof_parse_token_sets(struct snd_soc_compon=
ent *scomp,
 	int ret;
=20
 	while (array_size > 0 && total < count * token_instance_num) {
+		if (array_size < (int)sizeof(*array))
+			return -EINVAL;
+
 		asize =3D le32_to_cpu(array->size);
=20
 		/* validate asize */


8<---

The added check prevents a truncated-header read before dereferencing
array->size. The existing signed asize check then validates the declared
vendor-array size.

Let me know what you guys think.

--=20
Thanks,
C=C3=A1ssio


--------------1hYVgRe97fvA93KIF4BIXAZE--

--------------mSZlpNXjrCJz0CATVO2tiEZ9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQSrYqI5vIrg1X9eqEjQXT8aWv/ugwUCahy3GwUDAAAAAAAKCRDQXT8aWv/ugxGY
AQDkVN/9CBbQR+mih1YnWSZCtDHlaV6pP9TADLYVHzEXwgD9GuNk/uUQUa61Ug5Utfy0FhTpJ/aB
8dMKqGD5v6jsgAg=
=aOZM
-----END PGP SIGNATURE-----

--------------mSZlpNXjrCJz0CATVO2tiEZ9--
