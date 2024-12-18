Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com [209.85.218.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE28189B9F
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 08:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734512009; cv=none; b=HVPvLLcrpgpMoWMp/fOwf6OdMtUEPFJFCTwSXGssaAhJrKGSMjeczDtOPQCD49zz2QC45Fs4H+F+xIC31VCezrGrftzzaspvTTpcfckeoVkTJKD/y4dMEIKCt+9lkgq4Fex0QjKkqaqPuiaba+Av+nNyQRcK3MM4bG+evnLcP5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734512009; c=relaxed/simple;
	bh=wXx45+CQcraqpyFjOaDoL6gYGOrDfh+loCnXyj9mSb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OM9Ys5SzC2LS+SlRoxmyI8rew1DEef9n6VSFjDVqSE7a82zM5zWGmg6nRkTsDPo/k7d8tkRwiHBkLbLiypPXfpM2fXI2pgBx7mCFpzeKcZdzBqIjD/DMavnE5/rYSOMwg7l2x4SHcKvqlPluSViMirpy0WR0ENRVknhB/bP7W7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bSjPJiXF; arc=none smtp.client-ip=209.85.218.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bSjPJiXF"
Received: by mail-ej1-f66.google.com with SMTP id a640c23a62f3a-a9f1c590ecdso1072622766b.1
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 00:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1734512006; x=1735116806; darn=lists.linux.dev;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wXx45+CQcraqpyFjOaDoL6gYGOrDfh+loCnXyj9mSb0=;
        b=bSjPJiXF8HlKlHp7Oy6FhNC9WyA7QnHyZC0+0HoYZ/vhxBO9rZB/oIs7TqnXvYDFtZ
         QEysB/ftmmyheSLiUhfUGTetmVgZULoROFXjfRvjs7/6I6zr6sPoMcDLcU/Cx3LoT6WG
         nKYK36pm/vJz3wKPQGhosG2t4O7YmoaDUUi66sBoHetkBp5T76PMsHja5BpEP1HWbkBD
         rkilkti9wGjPSFwgxeY7SKN7/TB3NcBCN7Xz8AfhqX73lmBWD2kJ33h44RAPRr0GkpIN
         4srY6bCQ118TGo1EBX7suPtIM4PHv7LIGKiQpLNOqfHf8TJSt3II9NwjJEXAmDJ03Rv3
         0a/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734512006; x=1735116806;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wXx45+CQcraqpyFjOaDoL6gYGOrDfh+loCnXyj9mSb0=;
        b=IvqMJgy5OkQ8W2Uv5WPe+6+nVLcScE+5e3n5VJgVAGc624LqK2I2jnNKGCYv1Vr9Md
         fplr3tyDwSqB6wpHmQQEhVpKCQTAR2L+LzFpnybTH3EFkuJqnzhYR5odUtqm53MZ9nMO
         sgtrfrohP84u/8QPPzKyJlHC2D132xhKCKcBln0iy6Auu9eXt2A+6OCSGNgnQT2Nix57
         epivS8aRKmM14b7Ktr4wyuYkE01QRxvgPY/cSwB803PRnO751UM9ijGYTJ8BpoQ6YCYA
         /v2EO5GLTupgcU248OrlL2izxpePlQN/exf0tiyDxcKYiNc2GWfoOofjSyqe5Lo1ZlD3
         UBiw==
X-Gm-Message-State: AOJu0Yw92xBlRzWwNldIvWJTAW5ngQ0JKhKVmFQq4GW6yprTa7RbAv1X
	E9syLpavx97sZBrONZfk78+KsWeV3mjR+2vQfDL0rJCAtmk7WVD5Wq9d907eElo=
X-Gm-Gg: ASbGncsDKK81w520qkusTl9+QIeBep97g495vEAcPN3Q/pDz0H8X3UY17s/Q8s+m1J6
	bErtUPLxA04olA10BdPsRjyQmIgtSNkWotOn0TJubkdT0A9HhQOo+Iei4t+gDif18+h/7fVibJs
	1AwH/SBZYfEZxjSJuQXpuV3P+0q8DuWZoHkMfF/KulQVjnF78iAry5vUE9dbhdlaULd7sDB10Yh
	NKOql8kHRH0nqIAxCQJyVFQdv4UynqOTQSTYEBOtn1LCw+5oA6xljpUwTGscBU+8HgSGf+YJLZf
	2U4+M2PXWSS7hKB+u0B1x2Pm7SiKhEQ9wu+hlczV9pdVQlz6stFaZPMigznr6/9UVhYlU0/YafB
	WX0aoEg==
X-Google-Smtp-Source: AGHT+IFh5JR8AhqLfxC1Yu28XKe02fCtDAH5s1AGem0xojukWqQumyETAaFgEeUsxeoFCKhN/juv2g==
X-Received: by 2002:a17:907:785a:b0:aab:933c:4125 with SMTP id a640c23a62f3a-aabf4706799mr156775366b.10.1734512005763;
        Wed, 18 Dec 2024 00:53:25 -0800 (PST)
Received: from ?IPV6:2003:e5:8731:2800:842d:42a0:5992:3595? (p200300e587312800842d42a059923595.dip0.t-ipconnect.de. [2003:e5:8731:2800:842d:42a0:5992:3595])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aab963b2611sm534135866b.174.2024.12.18.00.53.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 00:53:25 -0800 (PST)
Message-ID: <aec47f97-c59b-403a-bf2a-d8551e2ec6f9@suse.com>
Date: Wed, 18 Dec 2024 09:53:24 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 168/172] x86/static-call: provide a way to do very
 early static-call updates
To: Jiri Slaby <jirislaby@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Andrew Cooper <andrew.cooper3@citrix.com>,
 Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>
References: <20241217170546.209657098@linuxfoundation.org>
 <20241217170553.299136607@linuxfoundation.org>
 <bf593d44-c59e-4158-b2c6-112372ab45d1@kernel.org>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <bf593d44-c59e-4158-b2c6-112372ab45d1@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------h7oGbIrrVYjo8PcW9Yg06fxx"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------h7oGbIrrVYjo8PcW9Yg06fxx
Content-Type: multipart/mixed; boundary="------------gqyGP6Mu2A408p15Izh7Q1Jy";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Jiri Slaby <jirislaby@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Andrew Cooper <andrew.cooper3@citrix.com>,
 Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <aec47f97-c59b-403a-bf2a-d8551e2ec6f9@suse.com>
Subject: Re: [PATCH 6.12 168/172] x86/static-call: provide a way to do very
 early static-call updates
References: <20241217170546.209657098@linuxfoundation.org>
 <20241217170553.299136607@linuxfoundation.org>
 <bf593d44-c59e-4158-b2c6-112372ab45d1@kernel.org>
In-Reply-To: <bf593d44-c59e-4158-b2c6-112372ab45d1@kernel.org>

--------------gqyGP6Mu2A408p15Izh7Q1Jy
Content-Type: multipart/mixed; boundary="------------P8Uks7JBwxUNNEIpZs7Sbn1v"

--------------P8Uks7JBwxUNNEIpZs7Sbn1v
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTguMTIuMjQgMDk6MzcsIEppcmkgU2xhYnkgd3JvdGU6DQo+IE9uIDE3LiAxMi4gMjQs
IDE4OjA4LCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+PiA2LjEyLXN0YWJsZSByZXZp
ZXcgcGF0Y2guwqAgSWYgYW55b25lIGhhcyBhbnkgb2JqZWN0aW9ucywgcGxlYXNlIGxldCBt
ZSBrbm93Lg0KPj4NCj4+IC0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4NCj4+IEZyb206IEp1ZXJn
ZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4+DQo+PiBjb21taXQgMGVmODA0N2I3Mzdk
NzQ4MGE1ZDRjNDZkOTU2ZTk3YzE5MGYxMzA1MCB1cHN0cmVhbS4NCj4+DQo+PiBBZGQgc3Rh
dGljX2NhbGxfdXBkYXRlX2Vhcmx5KCkgZm9yIHVwZGF0aW5nIHN0YXRpYy1jYWxsIHRhcmdl
dHMgaW4NCj4+IHZlcnkgZWFybHkgYm9vdC4NCj4+DQo+PiBUaGlzIHdpbGwgYmUgbmVlZGVk
IGZvciBzdXBwb3J0IG9mIFhlbiBndWVzdCB0eXBlIHNwZWNpZmljIGh5cGVyY2FsbA0KPj4g
ZnVuY3Rpb25zLg0KPj4NCj4+IFRoaXMgaXMgcGFydCBvZiBYU0EtNDY2IC8gQ1ZFLTIwMjQt
NTMyNDEuDQo+Pg0KPj4gUmVwb3J0ZWQtYnk6IEFuZHJldyBDb29wZXIgPGFuZHJldy5jb29w
ZXIzQGNpdHJpeC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jv
c3NAc3VzZS5jb20+DQo+PiBDby1kZXZlbG9wZWQtYnk6IFBldGVyIFppamxzdHJhIDxwZXRl
cnpAaW5mcmFkZWFkLm9yZz4NCj4+IENvLWRldmVsb3BlZC1ieTogSm9zaCBQb2ltYm9ldWYg
PGpwb2ltYm9lQHJlZGhhdC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhh
cnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPj4gLS0tDQo+PiDCoCBhcmNo
L3g4Ni9pbmNsdWRlL2FzbS9zdGF0aWNfY2FsbC5oIHzCoMKgIDE1ICsrKysrKysrKysrKysr
Kw0KPj4gwqAgYXJjaC94ODYvaW5jbHVkZS9hc20vc3luY19jb3JlLmjCoMKgIHzCoMKgwqAg
NiArKystLS0NCj4+IMKgIGFyY2gveDg2L2tlcm5lbC9zdGF0aWNfY2FsbC5jwqDCoMKgwqDC
oCB8wqDCoMKgIDkgKysrKysrKysrDQo+PiDCoCBpbmNsdWRlL2xpbnV4L2NvbXBpbGVyLmjC
oMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCAzNyArKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tLS0tLS0tLS0tDQo+PiDCoCBpbmNsdWRlL2xpbnV4L3N0YXRpY19jYWxsLmjCoMKgwqDC
oMKgwqDCoCB8wqDCoMKgIDEgKw0KPj4gwqAga2VybmVsL3N0YXRpY19jYWxsX2lubGluZS5j
wqDCoMKgwqDCoMKgwqAgfMKgwqDCoCAyICstDQo+PiDCoCA2IGZpbGVzIGNoYW5nZWQsIDU1
IGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KPj4NCj4+IC0tLSBhL2FyY2gveDg2
L2luY2x1ZGUvYXNtL3N0YXRpY19jYWxsLmgNCj4+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3N0YXRpY19jYWxsLmgNCj4+IEBAIC02NSw0ICs2NSwxOSBAQA0KPj4gwqAgZXh0ZXJu
IGJvb2wgX19zdGF0aWNfY2FsbF9maXh1cCh2b2lkICp0cmFtcCwgdTggb3AsIHZvaWQgKmRl
c3QpOw0KPj4gK2V4dGVybiB2b2lkIF9fc3RhdGljX2NhbGxfdXBkYXRlX2Vhcmx5KHZvaWQg
KnRyYW1wLCB2b2lkICpmdW5jKTsNCj4+ICsNCj4+ICsjZGVmaW5lIHN0YXRpY19jYWxsX3Vw
ZGF0ZV9lYXJseShuYW1lLCBfZnVuYynCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
XA0KPj4gKyh7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcDQo+PiArwqDCoMKgIHR5cGVvZigmU1RBVElD
X0NBTExfVFJBTVAobmFtZSkpIF9fRiA9IChfZnVuYyk7wqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBcDQo+PiArwqDCoMKgIGlmIChzdGF0aWNfY2FsbF9pbml0aWFsaXplZCkge8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwNCj4+ICvCoMKgwqDCoMKgwqDCoCBf
X3N0YXRpY19jYWxsX3VwZGF0ZSgmU1RBVElDX0NBTExfS0VZKG5hbWUpLMKgwqDCoMKgwqDC
oMKgIFwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFNU
QVRJQ19DQUxMX1RSQU1QX0FERFIobmFtZSksIF9fRik7XA0KPj4gK8KgwqDCoCB9IGVsc2Ug
e8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBcDQo+PiArwqDCoMKgwqDCoMKgwqAgV1JJVEVfT05DRShTVEFUSUNfQ0FMTF9LRVkobmFt
ZSkuZnVuYywgX2Z1bmMpO8KgwqDCoMKgwqDCoMKgIFwNCj4+ICvCoMKgwqDCoMKgwqDCoCBf
X3N0YXRpY19jYWxsX3VwZGF0ZV9lYXJseShTVEFUSUNfQ0FMTF9UUkFNUF9BRERSKG5hbWUp
LFwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBf
X0YpO8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXA0KPj4gK8KgwqDCoCB9wqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXA0K
Pj4gK30pDQo+IC4uLg0KPj4gLS0tIGEva2VybmVsL3N0YXRpY19jYWxsX2lubGluZS5jDQo+
PiArKysgYi9rZXJuZWwvc3RhdGljX2NhbGxfaW5saW5lLmMNCj4+IEBAIC0xNSw3ICsxNSw3
IEBAIGV4dGVybiBzdHJ1Y3Qgc3RhdGljX2NhbGxfc2l0ZSBfX3N0YXJ0X3MNCj4+IMKgIGV4
dGVybiBzdHJ1Y3Qgc3RhdGljX2NhbGxfdHJhbXBfa2V5IF9fc3RhcnRfc3RhdGljX2NhbGxf
dHJhbXBfa2V5W10sDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgX19zdG9wX3N0YXRpY19jYWxsX3RyYW1wX2tleVtdOw0KPj4gLXN0YXRpYyBpbnQg
c3RhdGljX2NhbGxfaW5pdGlhbGl6ZWQ7DQo+PiAraW50IHN0YXRpY19jYWxsX2luaXRpYWxp
emVkOw0KPiANCj4gVGhpcyBicmVha3MgdGhlIGJ1aWxkIG9uIGkzODY6DQo+PiBsZDogYXJj
aC94ODYveGVuL2VubGlnaHRlbi5vOiBpbiBmdW5jdGlvbiBgX194ZW5faHlwZXJjYWxsX3Nl
dGZ1bmMnOg0KPj4gZW5saWdodGVuLmM6KC5ub2luc3RyLnRleHQrMHgyYSk6IHVuZGVmaW5l
ZCByZWZlcmVuY2UgdG8gDQo+PiBgc3RhdGljX2NhbGxfaW5pdGlhbGl6ZWQnDQo+PiBsZDog
ZW5saWdodGVuLmM6KC5ub2luc3RyLnRleHQrMHg2Mik6IHVuZGVmaW5lZCByZWZlcmVuY2Ug
dG8gDQo+PiBgc3RhdGljX2NhbGxfaW5pdGlhbGl6ZWQnDQo+PiBsZDogYXJjaC94ODYva2Vy
bmVsL3N0YXRpY19jYWxsLm86IGluIGZ1bmN0aW9uIGBfX3N0YXRpY19jYWxsX3VwZGF0ZV9l
YXJseSc6DQo+PiBzdGF0aWNfY2FsbC5jOigubm9pbnN0ci50ZXh0KzB4MTUpOiB1bmRlZmlu
ZWQgcmVmZXJlbmNlIHRvIA0KPj4gYHN0YXRpY19jYWxsX2luaXRpYWxpemVkJw0KPiANCj4g
a2VybmVsL3N0YXRpY19jYWxsX2lubGluZS5jIGNvbnRhaW5pbmcgdGhpcyBgc3RhdGljX2Nh
bGxfaW5pdGlhbGl6ZWRgIGlzIG5vdCANCj4gYnVpbHQgdGhlcmUgYXM6DQo+IEhBVkVfU1RB
VElDX0NBTExfSU5MSU5FPW4NCj4gIMKgLT4gSEFWRV9PQkpUT09MPW4NCj4gIMKgwqDCoCAt
PiBYODZfNjQ9bg0KPiANCj4gVGhpcyBpcyBicm9rZW4gaW4gdXBzdHJlYW0gdG9vLg0KDQpJ
J3ZlIHNlbnQgYSBmaXggYWxyZWFkeToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGtt
bC8yMDI0MTIxODA4MDIyOC45NzQyLTEtamdyb3NzQHN1c2UuY29tL1QvI3UNCg0KDQpKdWVy
Z2VuDQo=
--------------P8Uks7JBwxUNNEIpZs7Sbn1v
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------P8Uks7JBwxUNNEIpZs7Sbn1v--

--------------gqyGP6Mu2A408p15Izh7Q1Jy--

--------------h7oGbIrrVYjo8PcW9Yg06fxx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmdijYQFAwAAAAAACgkQsN6d1ii/Ey9U
TQgAhhXKlEu6k6cOSFOd7TZ474peHVMlO2zJjRPK+PPydUM2XGwrEvJFJOCCuxKidDQmn8Tl2Fzj
FoDrewc04yGgp10mTxfVrhtlcvucBd4IuQwYsxv1o2cXOH2tr4VGqWnePXUY42I2h3v8KKB3AtVl
nLENBTAo1CXQSTUM6gUiaRHOCFyx09H4Sp4f53jNCLZFMs7rvJhzZjEbzEuJNGKDH3v6w0JP8Opr
/MbwMZcvwdK3T6zzHVzr+unB7gC41gYXj8MjfiTo7zD8p2teCZbsgXHVaqoRtA/oheQ5TaxqXksd
ldz19qdWMEPTCTqBp2vmQxDqEH6Qr/RlMHpRYuJyow==
=H51x
-----END PGP SIGNATURE-----

--------------h7oGbIrrVYjo8PcW9Yg06fxx--
