Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF6063C6
	for <patches@lists.linux.dev>; Thu,  2 Nov 2023 07:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VlgJjTaU"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-53f9af41444so977148a12.1
        for <patches@lists.linux.dev>; Thu, 02 Nov 2023 00:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1698909688; x=1699514488; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZzgMxS87UstitPyGkyQS3FJndMdCvFkV+kwkI7K4+Q=;
        b=VlgJjTaU7OtHrfgvYeKugoBfqz4DPnPRF2yP79RlfNPZrvc7GB8jXORugt3dIq268g
         A7+Z6fptlk7TO5he7sM0DR03o44BcDaQ6y4/nLuU5bCiWYYroddJX1xdd4Yvp+an0YHH
         JTSuMrpcpQYiKNxi/AK/Xa6ixsz8sSUzuEzjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698909688; x=1699514488;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ZzgMxS87UstitPyGkyQS3FJndMdCvFkV+kwkI7K4+Q=;
        b=kHjOhM/uhTD8ygfoA0G21OKVbDraapMWbP7IblqxX1i3KtggMlsq8cHCM0aeUvpjwP
         VGV7SFdrCEFDrr6MBYO8LOxzGZaSwnWXSIjzDbPpkcveLe7JxK6yBmiYNaad64S2Wb2b
         804nH34n+QKTHaiRtsZ7FSUnQEsDxTvYnqlt5LPxO2QXBn0/o2fTald2ZpGT80xxtl+r
         ZwwxsUUvcpVqaCZNTDhUqZxRo2drQ2uK0uB9TYo0vmsKk+S5y/uETF+KX6SiLzSOu9kL
         2Qp1MvZNFwyDOePt+cUY01thVCs4MFCGRT5JM7ncHiq7/CVPF1CWDTC6AJOM0qCc4ycU
         UoXw==
X-Gm-Message-State: AOJu0Yx22NSRCXeF7lQiylNymY5Ja6LKUfbaRBYhmBtx73PwAmPLRGH/
	KAvta973mqvts23TB73HM2ktn/VOOKuT3fK2a1/IgtWy
X-Google-Smtp-Source: AGHT+IGiAUqcMWfRkQdTjKaHyBJ/1OWkGgsVNednV3/KjBzS3oHGMSCNxiWaKJBQdYd0JWxM+hDaHg==
X-Received: by 2002:a05:6402:2031:b0:532:c08a:eac0 with SMTP id ay17-20020a056402203100b00532c08aeac0mr15551772edb.26.1698909688127;
        Thu, 02 Nov 2023 00:21:28 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id o7-20020a056402038700b00540ea3a25e6sm1931878edv.72.2023.11.02.00.21.27
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Nov 2023 00:21:27 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-53f9af41444so977105a12.1
        for <patches@lists.linux.dev>; Thu, 02 Nov 2023 00:21:27 -0700 (PDT)
X-Received: by 2002:a17:907:7ea4:b0:9be:8ead:54c7 with SMTP id
 qb36-20020a1709077ea400b009be8ead54c7mr3648207ejc.12.1698909686859; Thu, 02
 Nov 2023 00:21:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZUKxT1CL9/0Dn6NE@bombadil.infradead.org> <CAHk-=whFXNYXG2ES8HdoaMC=O4bakMXGZezmoqA3SXwn4xJUPQ@mail.gmail.com>
In-Reply-To: <CAHk-=whFXNYXG2ES8HdoaMC=O4bakMXGZezmoqA3SXwn4xJUPQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Nov 2023 21:21:09 -1000
X-Gmail-Original-Message-ID: <CAHk-=wi=goCaTm6ZOKzm_ztky9ZT-vuGDWv39vVdtQT+oW=zEg@mail.gmail.com>
Message-ID: <CAHk-=wi=goCaTm6ZOKzm_ztky9ZT-vuGDWv39vVdtQT+oW=zEg@mail.gmail.com>
Subject: Re: [GIT PULL] Modules changes for v6.7-rc1
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-modules@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, andrea.righi@canonical.com, 
	keescook@chromium.org, zhumao001@208suo.com, yangtiezhu@loongson.cn, 
	ojeda@kernel.org
Content-Type: multipart/mixed; boundary="000000000000642f940609263c74"

--000000000000642f940609263c74
Content-Type: text/plain; charset="UTF-8"

On Wed, 1 Nov 2023 at 21:02, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> kmalloc() isn't just about "use physically contiguous allocations".
> It's also more memory-efficient, and a *lot* faster than vmalloc(),
> which has to play VM tricks.

I've pulled this, but I think you should do something like the
attached (UNTESTED!) patch.

                Linus

--000000000000642f940609263c74
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_loguy4k40>
X-Attachment-Id: f_loguy4k40

IGtlcm5lbC9tb2R1bGUvZGVjb21wcmVzcy5jIHwgOCArKysrLS0tLQogMSBmaWxlIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvbW9k
dWxlL2RlY29tcHJlc3MuYyBiL2tlcm5lbC9tb2R1bGUvZGVjb21wcmVzcy5jCmluZGV4IDQxNTZk
NTliZTQ0MC4uNDc0ZTY4ZjBmMDYzIDEwMDY0NAotLS0gYS9rZXJuZWwvbW9kdWxlL2RlY29tcHJl
c3MuYworKysgYi9rZXJuZWwvbW9kdWxlL2RlY29tcHJlc3MuYwpAQCAtMTAwLDcgKzEwMCw3IEBA
IHN0YXRpYyBzc2l6ZV90IG1vZHVsZV9nemlwX2RlY29tcHJlc3Moc3RydWN0IGxvYWRfaW5mbyAq
aW5mbywKIAlzLm5leHRfaW4gPSBidWYgKyBnemlwX2hkcl9sZW47CiAJcy5hdmFpbF9pbiA9IHNp
emUgLSBnemlwX2hkcl9sZW47CiAKLQlzLndvcmtzcGFjZSA9IHZtYWxsb2MoemxpYl9pbmZsYXRl
X3dvcmtzcGFjZXNpemUoKSk7CisJcy53b3Jrc3BhY2UgPSBrdm1hbGxvYyh6bGliX2luZmxhdGVf
d29ya3NwYWNlc2l6ZSgpLCBHRlBfS0VSTkVMKTsKIAlpZiAoIXMud29ya3NwYWNlKQogCQlyZXR1
cm4gLUVOT01FTTsKIApAQCAtMTM4LDcgKzEzOCw3IEBAIHN0YXRpYyBzc2l6ZV90IG1vZHVsZV9n
emlwX2RlY29tcHJlc3Moc3RydWN0IGxvYWRfaW5mbyAqaW5mbywKIG91dF9pbmZsYXRlX2VuZDoK
IAl6bGliX2luZmxhdGVFbmQoJnMpOwogb3V0OgotCXZmcmVlKHMud29ya3NwYWNlKTsKKwlrdmZy
ZWUocy53b3Jrc3BhY2UpOwogCXJldHVybiByZXR2YWw7CiB9CiAjZWxpZiBkZWZpbmVkKENPTkZJ
R19NT0RVTEVfQ09NUFJFU1NfWFopCkBAIC0yNDEsNyArMjQxLDcgQEAgc3RhdGljIHNzaXplX3Qg
bW9kdWxlX3pzdGRfZGVjb21wcmVzcyhzdHJ1Y3QgbG9hZF9pbmZvICppbmZvLAogCX0KIAogCXdr
c3Bfc2l6ZSA9IHpzdGRfZHN0cmVhbV93b3Jrc3BhY2VfYm91bmQoaGVhZGVyLndpbmRvd1NpemUp
OwotCXdrc3AgPSB2bWFsbG9jKHdrc3Bfc2l6ZSk7CisJd2tzcCA9IGt2bWFsbG9jKHdrc3Bfc2l6
ZSwgR0ZQX0tFUk5FTCk7CiAJaWYgKCF3a3NwKSB7CiAJCXJldHZhbCA9IC1FTk9NRU07CiAJCWdv
dG8gb3V0OwpAQCAtMjg0LDcgKzI4NCw3IEBAIHN0YXRpYyBzc2l6ZV90IG1vZHVsZV96c3RkX2Rl
Y29tcHJlc3Moc3RydWN0IGxvYWRfaW5mbyAqaW5mbywKIAlyZXR2YWwgPSBuZXdfc2l6ZTsKIAog
IG91dDoKLQl2ZnJlZSh3a3NwKTsKKwlrdmZyZWUod2tzcCk7CiAJcmV0dXJuIHJldHZhbDsKIH0K
ICNlbHNlCg==
--000000000000642f940609263c74--
