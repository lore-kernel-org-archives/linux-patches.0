Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794237785;
	b=YUkSs6CsAoUbobYFu0M99CsuvI9zaQS5nUfwKtnBreTPgdh4gfmS1cx79K0CwnNawfJg
	 dGWgMA1QCwo+qY4pU57SRA3jLQ/8Gq3ShWp0lLCDmjcZ7Jvf8LwZ/vXcY+qKITa+M0z9i
	 ixB11OyX4m1Qzwu6NNXOLimqw/ROJEGiTkcaaA0FWDnopHt5GCvXLPWjq1865N1PrlcOw
	 TUO1JzSy4Jf7eVJdcvOMFLpphMTVqWPUVJ6jdnZc4HRXT0ymO49TNg+wxocR+TH79fEx6
	 upia3dPh5k4CBa2vOgQsZP/Pwpgnqs4NTT2Me/Lyjqh+AtroILxvGPkyTNKR878zWog==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794237785;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=mApsEmVz45av3S3Isn3l9iP+qpSKEvIgCT0J/QQ/dgA=;
	b=QCxIocbthhXnMD7optQWYXpj8h2MdZfgDe3kYPYtohfriZ1i2+DufCD3/xHdp74u9HeD
	 VUAjS4HR7jRKWzn3qw4i5nXj2/mUlmMnPFECu2ydvWbZcbw57u9Dz1DwHwRZQqhV+IHIf
	 5MT8OBY+fi/9OFo4UzicMIgLccafe/snOCssTaQL66DkJbqTaQLbwVf856t6vqFHD/NjF
	 fT7htavfkE+HcBzGVSmXWmMjIYW+HIUk192IExtPKRaSA0ppb6YVcHBfkS2lem/DyrwhU
	 Q8sMGpr9+S55eeEMuJDQm/7EfdHUAA2YSRbfEbzvuQ4at8B3uvrveGHx43oYlnhSl3w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B686iJ+i;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86550606A32A
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 15:23:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86550606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B686iJ+i
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4cdc606b47so145300766b.0
        for <patches@lists.linux.dev>; Mon, 09 Nov 2026 07:23:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794237784; cv=none;
        d=google.com; s=arc-20260327;
        b=lAQYqJyA5mOUC3CUTRF/vwgZNFDsmIdEnh6BjydVF+tl1OEPtPM+zcjLJ7I4nGnroP
         0Jv0cqPUspWxgf/PqhVYAHLI7+pVY38tcnW7JshLyuH/WnApr7Zg71tK7mqIgs34DpQz
         hBwAi7ZEiM9iCO60i+JmtaMGEYFA0CKAlclhFLb+2/Sd8UfnjgXrx8Bd226YCNfhR1sP
         9X950hXnScgNlLL5ZxDIggL6LCWKh4OqyFzHxZPkZ2fG6a4w4HXHoW1UK1LeMRq0K9Tm
         rU7iBQZwgP3r1KKc0GNM4Y9M9iKMS1wlFfeZxOVP7CqrF0jibrg27B5rAAAjcRxmiI34
         cZZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=mApsEmVz45av3S3Isn3l9iP+qpSKEvIgCT0J/QQ/dgA=;
        fh=uGEzfFsNA5F2eL6BGT5bL8ZmB7yvXvz+TdFChcKXBP8=;
        b=TT57gFfqDCXxiNw5Vck3HR2ukZxX37L6hsBHhD3vfZQVJ0OcStupJ2tXHiG2qwKcqg
         6eRbHsA1TpgHZz2IyLCDLgjOsSQxHCsXl9+5kv3uQ3EXTLow3HlWA/JUmLXTmJnczP6n
         3QYtkpHEUFI5gNSxFPUJZWhvCrfEiBkkMP0MZSg1LEGdrN0kjK1xvZml1BOqEw/62UI3
         uaup4UfUEwS5QfRLqedvhfoqxKQoAuf1PIFCT/x0NDh/ijFAvFsmQlQnOua95N2uvogG
         c7BgRmSJpMnv1Q9FkMd3aqeSazSSv3WrDzrBJuBjonqxcm4xd+IxGT2JpkJIsPhgYULl
         sxDg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794237784; x=1794842584; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mApsEmVz45av3S3Isn3l9iP+qpSKEvIgCT0J/QQ/dgA=;
        b=B686iJ+iMm7h/bnZebTaMG6DHBmYHJZ6OoX/j4KpCG6Zlq2uZu5L/r7vZv9KSKUhd5
         eog5y0xCGWOLwnktnH2GZQoX9hnokPEAwTVMdSC5UiCR78sKNU9gl1zZFQIpX3kMCV1W
         U01+uErZmgGW9CiAJbnNgUWFwAnHxeYWnCw5kht9zOaLFhFSj1jBQL+Y49zEJGpcchMQ
         HH3NrRrcpSs6wYg8RO+9Wsn38ob8hXrYFCOmo5gYbZvqMeYzzoraJBIx97LVvLIEUr2a
         sV2LopMTuoCXnamcUnqnsI0pyEpyQnpu8lXDEfu4u7cKXCqmyenSsJj/9N8Jw4JxIAMA
         4whw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794237784; x=1794842584;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mApsEmVz45av3S3Isn3l9iP+qpSKEvIgCT0J/QQ/dgA=;
        b=z6QUATxOeL5m/gRy222fVYOMdgkA5BiwVHlzGdcm+yEG1Eg3n8oKX2YYcQ24LJ2eWH
         zzUNO9TccYyVxtcEZ2DleP5bOqOOFM7wfKfr+oH39+v154b758YCgZNiOEqWLq2cKjyr
         yEEZALw0hTozo7+AccH2dmSo1nG+XEyz8nA3T6xwU5HpGjNVbdqB9W8LvcwuQ1I+ZCa4
         i0iDwReb4ALtsDRAVZuV46KiygZWWiMbl254TcTinWhHGK/rdLV32UH0q2Sy+Pk2yqhS
         nJfwDWO+BubdqzKlZZ0ZuFS4rGl+NhHleS+2EMjH/mMGbGI7t2MNs0ajl0K6X48SkqDR
         1q+w==
X-Forwarded-Encrypted: i=1; AL+hErEthn2x+5ZKdDisKFX8w1mTNXLUFHjU9wSFnSQLV68Gc7uDqMEjxaA4BS70PaxjTM+iEsBwIwmz@lists.linux.dev
X-Gm-Message-State: APuU4Z+aFarOXUk5IPYTSwtD37inusp5K/wfcZVSU31WZg7JV/IlwB1M
	W1cUroCeVwUoWjA2pvbdduCw8UmOwo54tTdnqaIzQuBmsoJejBvhmUOFaUt5e2erxFXUVE69/Y7
	70keIdulZomyveJbrMIJ82Ww+IzefFUAxYMF9ShI=
X-Gm-Gg: AYBFou1zYm07qwWiRCnXTI3GNEPdKaqlx7uT38s5PDA0S4SRiGD3bhQ45Oda1nVccYG
	7Bcjhbexv4N0mx62e3yFMqAFtQgAnflWc+OqYjdRQKV210SS8OItpxzPZWIEobiVVggQhdTsoQR
	urHD8JD+pM+41PfqvOmypiiz7p8uDBEgLmrffUm8PwnQMZ6l5tfdRkuFjME6WFYP5EIl9frSLKy
	/Gn4SeL7+IRZkRfp2Q63Fs4aRXB0FegqoULTu9TzlAB3XevHE5Yh4Wwy9rzD1GfH0E14JO0zDeB
	5eeKjXJNTEHCz1CWTkh4kI+QXgrPcO16ZVV847jSxp5909PBvVyeBa5qz2hlJW1Jg2VpylY/PLX
	V0hTgpKws3vxvMiRLHCxTUkVfjsOo0jrbNLlZA/UmwExAm8U7EUi9M/PDvL9iAtbciO8=
X-Received: by 2002:a17:907:96ab:b0:c2e:4b90:3c53 with SMTP id
 a640c23a62f3a-c4d6d99453fmr378630766b.1.1794237783678; Mon, 09 Nov 2026
 07:23:03 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
From: Ramon Meireles da Silva <ramon.meireles32@gmail.com>
Date: Mon, 9 Nov 2026 12:22:51 -0300
X-Gm-Features: AclHuK-w58PVG-3Os21lYfOSRUZGOuontPIR_EhX9rP80uKsBIlg29W-z9VIghM
Message-ID: <CAN-h+BLrxhQv_Juva1P-es9m5Yk0Tv3OsxD_KM_nXxz4YiHs=g@mail.gmail.com>
Subject: Re: [PATCH 7.3 0013/1257] drm/nouveau/gsp/r570: Set GcOff = 0 in fbsr
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org, lyude@redhat.com, airlied@redhat.com, 
	sashal@kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sat, 07 Nov 2026 13:49:39 +0000, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> ------------------
> From: Lyude Paul <lyude@redhat.com>
>
> [ Upstream commit c7abe771e013848970421e5ca29c6b2f05c31965 ]
>
> Previously, it looked as if we were able to fix suspend/resume on some
> desktops by setting Gcoff based on whether or not we were entering runtime
> PM. This was a mistake though - the only time suspend/resume would end up
> actually working was if Gcoff = 0.
[...]
> - ctrl->bEnteringGcoffState = 1;
> + ctrl->bEnteringGcoffState = 0;
>   ret = nvkm_gsp_rm_ctrl_wr(&gsp->internal.device.subdevice, ctrl);

Please do not merge this patch into stable 7.3.

Setting bEnteringGcoffState = 0 along the patches introduced in
mainline 7.3.x may break resume from suspend, this patch was a
temporary solution in 7.2.8. In 7.3.3 suspend/resume cycle in nouveau
is properly working, you actually merged this commit twice for no
reason.
my hardware: NVIDIA RTX 3050 Laptop GPU/ Intel iGPU hybrid setup.
