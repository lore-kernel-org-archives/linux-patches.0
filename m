Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD728A42
	for <patches@lists.linux.dev>; Tue, 30 May 2023 01:55:55 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-96f6a9131fdso586768666b.1
        for <patches@lists.linux.dev>; Mon, 29 May 2023 18:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685411753; x=1688003753;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qep/fhA3jgUMujeeTKyTERwp6K6SL5nBAck6MsjUsdI=;
        b=iCYMB2Vtu0qjD2aCHNswGcR/y3aPdw6Bn2Mgqm3oILKJPtLTKCQhC9iBwtfvW7VlOy
         Nvf/lIW6pPvfN6/MhtkkZL+MRreYBSyWjYaTt6C+Tr/CqsnYjTIofks3FOE5dAQyts4a
         aXrUACz6ZAY8VogOSbphrEowgjtm4FbPMZJrs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685411753; x=1688003753;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qep/fhA3jgUMujeeTKyTERwp6K6SL5nBAck6MsjUsdI=;
        b=Js6utLYUS8hBYH3hVkcQ2eUeY6O1CZ/NnBjdo6X7YplsrPI1tdi4rt33TJYUrieBjI
         WnPeyWEozIZ2lzJkR2FeABWOcCvy6XCvPRyDStqBKLu9t4v5IEbrp0NC6WBqWxM6Oyqu
         zUOV8RE2y4Luco3tpoCNkhS/sXYtuyS9Gs5TjwEWsAI2/J0K6b0PBfXDU7D9rTj/lI0t
         FaE9n1DuwulQSK2SLbP304/2XT7tIc/kzFFH8DHhvkivpnwmZ2pvMOKuxpR3N4t57Kft
         nlrw2QU1lY1c2fixRyTd16KCGKLoaPtx3xXILSHTcps3c4//TZ94Al5XP6oMx1WEwy3g
         Ybdg==
X-Gm-Message-State: AC+VfDyeBNESiFScxEQcdwyKfPyuXj7ZpLu/qXvd6J20tDS5RuRhG0Ry
	MPMVq8i4UwoD06yf0xFe9hPDab2xk2M0B/kUHl70kORs
X-Google-Smtp-Source: ACHHUZ5EgmXNnEYO7EzmR94CFtAzTbESBL26OILHyfEs4lnS8oUaKZm/UDXjNkWpHVcYKK3dkH4B3Q==
X-Received: by 2002:a17:907:1b09:b0:969:dda1:38a4 with SMTP id mp9-20020a1709071b0900b00969dda138a4mr1000905ejc.38.1685411753609;
        Mon, 29 May 2023 18:55:53 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id qu2-20020a170907110200b00947ed087a2csm6612866ejb.154.2023.05.29.18.55.52
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 18:55:53 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-514953b3aa6so3126243a12.1
        for <patches@lists.linux.dev>; Mon, 29 May 2023 18:55:52 -0700 (PDT)
X-Received: by 2002:a17:907:26c7:b0:973:92d4:9f4e with SMTP id
 bp7-20020a17090726c700b0097392d49f4emr754163ejc.53.1685411732076; Mon, 29 May
 2023 18:55:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524213620.3509138-3-mcgrof@kernel.org> <8fc5b26b-d2f6-0c8f-34a1-af085dbef155@suse.com>
 <CAHk-=wiPjcPL_50WRWOi-Fmi9TYO6yp_oj63a_N84FzG-rxGKQ@mail.gmail.com>
 <6gwjomw6sxxmlglxfoilelswv4hgygqelomevb4k4wrlrk3gtm@wrakbmwztgeu>
 <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com>
 <ZG/a+nrt4/AAUi5z@bombadil.infradead.org> <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
 <ZHRpH-JXAxA6DnzR@hovoldconsulting.com> <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
 <ZHSeOUpKtyc8VKx5@hovoldconsulting.com> <ZHTCK2_1pF61yWIr@hovoldconsulting.com>
In-Reply-To: <ZHTCK2_1pF61yWIr@hovoldconsulting.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 May 2023 21:55:15 -0400
X-Gmail-Original-Message-ID: <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>
Message-ID: <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
To: Johan Hovold <johan@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Lucas De Marchi <lucas.demarchi@intel.com>, 
	Petr Pavlu <petr.pavlu@suse.com>, gregkh@linuxfoundation.org, rafael@kernel.org, 
	song@kernel.org, lucas.de.marchi@gmail.com, christophe.leroy@csgroup.eu, 
	peterz@infradead.org, rppt@kernel.org, dave@stgolabs.net, willy@infradead.org, 
	vbabka@suse.cz, mhocko@suse.com, dave.hansen@linux.intel.com, 
	colin.i.king@gmail.com, jim.cromie@gmail.com, catalin.marinas@arm.com, 
	jbaron@akamai.com, rick.p.edgecombe@intel.com, yujie.liu@intel.com, 
	david@redhat.com, tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev, 
	linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com, 
	lennart@poettering.net
Content-Type: multipart/mixed; boundary="0000000000009785e105fcdf7f38"

--0000000000009785e105fcdf7f38
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 29, 2023 at 11:18=E2=80=AFAM Johan Hovold <johan@kernel.org> wr=
ote:
>
> I took a closer look at some of the modules that failed to load and
> noticed a pattern in that they have dependencies that are needed by more
> than one device.

Ok, this is a "maybe something like this" RFC series of two patches -
one trivial one to re-organize things a bit so that we can then do the
real one which uses a filter based on the inode pointer to return an
"idempotent return value" for module loads that share the same inode.

It's entirely untested, and since I'm on the road I'm going to not
really be able to test it. It compiles for me, and the code looks
fairly straightforward, but it's probably buggy.

It's very loosely based on Luis' attempt,  but it
 (a) is internal to module loading
 (b) uses a reliable cookie
 (c) doesn't leave the cookie around randomly for later
 (d) has seen absolutely no testing

Put another way: if somebody wants to play with this, please treat it
as a starting point, not the final thing. You might need to debug
things, and fix silly mistakes.

The idea is to just have a simple hash list of currently executing
module loads, protected by a trivial spinlock. Every module loader
adds itself to the right hash list, and if they were the *first* one
(ie no other pending module loads for that inode), will actually do
the module load.

Everybody who *isn't* the first one will just wait for completion and
return the same error code that the first one returned.

This is technically bogus. The first one might fail due to arguments.
So the cookie shouldn't be just the inode, it should be the inode and
a hash of the arguments or something like that. But it is what it is,
and apart from possible show-stopper bugs this is no worse than the
failed "exclusive write deny" attempt. IOW - maybe worth trying?

And if *that* didn't sell people on this patch series, I don't know
what will. I should be in marketing! Two drink minimums, here I come!

               Linus

--0000000000009785e105fcdf7f38
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-module-split-up-finit_module-into-init_module_from_f.patch"
Content-Disposition: attachment; 
	filename="0001-module-split-up-finit_module-into-init_module_from_f.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_li9mlfcx0>
X-Attachment-Id: f_li9mlfcx0

RnJvbSBiN2QxOWFmMWIyYTNjYTlmNzg5ZGY5YzA0MTQ3NTc2ZmNhN2M1YjhmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRh
dGlvbi5vcmc+CkRhdGU6IE1vbiwgMjkgTWF5IDIwMjMgMjA6NTU6MTMgLTA0MDAKU3ViamVjdDog
W1BBVENIIDEvMl0gbW9kdWxlOiBzcGxpdCB1cCAnZmluaXRfbW9kdWxlKCknIGludG8KIGluaXRf
bW9kdWxlX2Zyb21fZmlsZSgpIGhlbHBlcgoKVGhpcyB3aWxsIHNpbXBsaWZ5IHRoZSBuZXh0IHN0
ZXAsIHdoZXJlIHdlIGNhbiB0aGVuIGtleSBvZmYgdGhlIGlub2RlIHRvCmRvIG9uZSBpZGVtcG90
ZW50IG1vZHVsZSBsb2FkLgoKTGV0J3MgZG8gdGhlIG9idmlvdXMgcmUtb3JnYW5pemF0aW9uIGlu
IG9uZSBzdGVwLCBhbmQgdGhlbiB0aGUgbmV3IGNvZGUKaW4gYW5vdGhlci4KClNpZ25lZC1vZmYt
Ynk6IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4KLS0tCiBr
ZXJuZWwvbW9kdWxlL21haW4uYyB8IDQyICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9tb2R1bGUvbWFpbi5jIGIva2VybmVsL21vZHVsZS9t
YWluLmMKaW5kZXggMDQ0YWEyYzllM2NiLi40MjdiZmZhMjg0NGYgMTAwNjQ0Ci0tLSBhL2tlcm5l
bC9tb2R1bGUvbWFpbi5jCisrKyBiL2tlcm5lbC9tb2R1bGUvbWFpbi5jCkBAIC0zMDU3LDI2ICsz
MDU3LDE2IEBAIFNZU0NBTExfREVGSU5FMyhpbml0X21vZHVsZSwgdm9pZCBfX3VzZXIgKiwgdW1v
ZCwKIAlyZXR1cm4gbG9hZF9tb2R1bGUoJmluZm8sIHVhcmdzLCAwKTsKIH0KIAotU1lTQ0FMTF9E
RUZJTkUzKGZpbml0X21vZHVsZSwgaW50LCBmZCwgY29uc3QgY2hhciBfX3VzZXIgKiwgdWFyZ3Ms
IGludCwgZmxhZ3MpCitzdGF0aWMgaW50IGluaXRfbW9kdWxlX2Zyb21fZmlsZShzdHJ1Y3QgZmls
ZSAqZiwgY29uc3QgY2hhciBfX3VzZXIgKiB1YXJncywgaW50IGZsYWdzKQogewogCXN0cnVjdCBs
b2FkX2luZm8gaW5mbyA9IHsgfTsKIAl2b2lkICpidWYgPSBOVUxMOwogCWludCBsZW47Ci0JaW50
IGVycjsKIAotCWVyciA9IG1heV9pbml0X21vZHVsZSgpOwotCWlmIChlcnIpCi0JCXJldHVybiBl
cnI7CisJaWYgKCFmIHx8ICEoZi0+Zl9tb2RlICYgRk1PREVfUkVBRCkpCisJCXJldHVybiAtRUJB
REY7CiAKLQlwcl9kZWJ1ZygiZmluaXRfbW9kdWxlOiBmZD0lZCwgdWFyZ3M9JXAsIGZsYWdzPSVp
XG4iLCBmZCwgdWFyZ3MsIGZsYWdzKTsKLQotCWlmIChmbGFncyAmIH4oTU9EVUxFX0lOSVRfSUdO
T1JFX01PRFZFUlNJT05TCi0JCSAgICAgIHxNT0RVTEVfSU5JVF9JR05PUkVfVkVSTUFHSUMKLQkJ
ICAgICAgfE1PRFVMRV9JTklUX0NPTVBSRVNTRURfRklMRSkpCi0JCXJldHVybiAtRUlOVkFMOwot
Ci0JbGVuID0ga2VybmVsX3JlYWRfZmlsZV9mcm9tX2ZkKGZkLCAwLCAmYnVmLCBJTlRfTUFYLCBO
VUxMLAotCQkJCSAgICAgICBSRUFESU5HX01PRFVMRSk7CisJbGVuID0ga2VybmVsX3JlYWRfZmls
ZShmLCAwLCAmYnVmLCBJTlRfTUFYLCBOVUxMLCBSRUFESU5HX01PRFVMRSk7CiAJaWYgKGxlbiA8
IDApIHsKIAkJbW9kX3N0YXRfaW5jKCZmYWlsZWRfa3JlYWRzKTsKIAkJbW9kX3N0YXRfYWRkX2xv
bmcobGVuLCAmaW52YWxpZF9rcmVhZF9ieXRlcyk7CkBAIC0zMDg0LDcgKzMwNzQsNyBAQCBTWVND
QUxMX0RFRklORTMoZmluaXRfbW9kdWxlLCBpbnQsIGZkLCBjb25zdCBjaGFyIF9fdXNlciAqLCB1
YXJncywgaW50LCBmbGFncykKIAl9CiAKIAlpZiAoZmxhZ3MgJiBNT0RVTEVfSU5JVF9DT01QUkVT
U0VEX0ZJTEUpIHsKLQkJZXJyID0gbW9kdWxlX2RlY29tcHJlc3MoJmluZm8sIGJ1ZiwgbGVuKTsK
KwkJaW50IGVyciA9IG1vZHVsZV9kZWNvbXByZXNzKCZpbmZvLCBidWYsIGxlbik7CiAJCXZmcmVl
KGJ1Zik7IC8qIGNvbXByZXNzZWQgZGF0YSBpcyBubyBsb25nZXIgbmVlZGVkICovCiAJCWlmIChl
cnIpIHsKIAkJCW1vZF9zdGF0X2luYygmZmFpbGVkX2RlY29tcHJlc3MpOwpAQCAtMzA5OSw2ICsz
MDg5LDI4IEBAIFNZU0NBTExfREVGSU5FMyhmaW5pdF9tb2R1bGUsIGludCwgZmQsIGNvbnN0IGNo
YXIgX191c2VyICosIHVhcmdzLCBpbnQsIGZsYWdzKQogCXJldHVybiBsb2FkX21vZHVsZSgmaW5m
bywgdWFyZ3MsIGZsYWdzKTsKIH0KIAorU1lTQ0FMTF9ERUZJTkUzKGZpbml0X21vZHVsZSwgaW50
LCBmZCwgY29uc3QgY2hhciBfX3VzZXIgKiwgdWFyZ3MsIGludCwgZmxhZ3MpCit7CisJaW50IGVy
cjsKKwlzdHJ1Y3QgZmQgZjsKKworCWVyciA9IG1heV9pbml0X21vZHVsZSgpOworCWlmIChlcnIp
CisJCXJldHVybiBlcnI7CisKKwlwcl9kZWJ1ZygiZmluaXRfbW9kdWxlOiBmZD0lZCwgdWFyZ3M9
JXAsIGZsYWdzPSVpXG4iLCBmZCwgdWFyZ3MsIGZsYWdzKTsKKworCWlmIChmbGFncyAmIH4oTU9E
VUxFX0lOSVRfSUdOT1JFX01PRFZFUlNJT05TCisJCSAgICAgIHxNT0RVTEVfSU5JVF9JR05PUkVf
VkVSTUFHSUMKKwkJICAgICAgfE1PRFVMRV9JTklUX0NPTVBSRVNTRURfRklMRSkpCisJCXJldHVy
biAtRUlOVkFMOworCisJZiA9IGZkZ2V0KGZkKTsKKwllcnIgPSBpbml0X21vZHVsZV9mcm9tX2Zp
bGUoZi5maWxlLCB1YXJncywgZmxhZ3MpOworCWZkcHV0KGYpOworCXJldHVybiBlcnI7Cit9CisK
IC8qIEtlZXAgaW4gc3luYyB3aXRoIE1PRFVMRV9GTEFHU19CVUZfU0laRSAhISEgKi8KIGNoYXIg
Km1vZHVsZV9mbGFncyhzdHJ1Y3QgbW9kdWxlICptb2QsIGNoYXIgKmJ1ZiwgYm9vbCBzaG93X3N0
YXRlKQogewotLSAKMi40MC4wLnJjMS4yLmdkMTU2NDRmZTAyCgo=
--0000000000009785e105fcdf7f38
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-modules-catch-concurrent-module-loads-take-two.patch"
Content-Disposition: attachment; 
	filename="0002-modules-catch-concurrent-module-loads-take-two.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_li9mlkax1>
X-Attachment-Id: f_li9mlkax1

RnJvbSBjODQ0MDk5YWI0ZDMwMzI0MjRiNGJmODcyMGU3NjFmYmNjZjg4ZWE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRh
dGlvbi5vcmc+CkRhdGU6IE1vbiwgMjkgTWF5IDIwMjMgMjE6Mzk6NTEgLTA0MDAKU3ViamVjdDog
W1BBVENIIDIvMl0gbW9kdWxlczogY2F0Y2ggY29uY3VycmVudCBtb2R1bGUgbG9hZHMsIHRha2Ug
dHdvCgpUaGlzIHRyZWF0cyBjb25jdXJyZW50IG1vZHVsZSBsb2FkcyBmcm9tIGEgZmlsZSBhcyAi
aWRlbXBvdGVudCIgaW4gdGhlCmlub2RlLCBpZSBpZiBvbmUgbW9kdWxlIGxvYWQgaXMgb25nb2lu
Zywgd2UgZG9uJ3Qgc3RhcnQgYSBuZXcgb25lLCBidXQKaW5zdGVhZCBqdXN0IGV4cGVjdCB0aGUg
Zmlyc3Qgb25lIHRvIGNvbXBsZXRlIGFuZCByZXR1cm4gdGhlIHNhbWUgcmV0dXJuCnZhbHVlIGFz
IGl0IGRpZC4KClNpZ25lZC1vZmYtYnk6IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1m
b3VuZGF0aW9uLm9yZz4KLS0tCiBrZXJuZWwvbW9kdWxlL21haW4uYyB8IDczICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNzEgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvbW9kdWxlL21h
aW4uYyBiL2tlcm5lbC9tb2R1bGUvbWFpbi5jCmluZGV4IDQyN2JmZmEyODQ0Zi4uODJiMGRjYzFm
ZTc3IDEwMDY0NAotLS0gYS9rZXJuZWwvbW9kdWxlL21haW4uYworKysgYi9rZXJuZWwvbW9kdWxl
L21haW4uYwpAQCAtMzA1NywxNSArMzA1Nyw4MiBAQCBTWVNDQUxMX0RFRklORTMoaW5pdF9tb2R1
bGUsIHZvaWQgX191c2VyICosIHVtb2QsCiAJcmV0dXJuIGxvYWRfbW9kdWxlKCZpbmZvLCB1YXJn
cywgMCk7CiB9CiAKK3N0cnVjdCBpZGVtcG90ZW50IHsKKwljb25zdCB2b2lkICpjb29raWU7CisJ
c3RydWN0IGhsaXN0X25vZGUgZW50cnk7CisJc3RydWN0IGNvbXBsZXRpb24gY29tcGxldGU7CisJ
aW50IHJldDsKK307CisKKyNkZWZpbmUgSURFTV9IQVNIX0JJVFMgOAorc3RhdGljIHN0cnVjdCBo
bGlzdF9oZWFkIGlkZW1faGFzaFsxIDw8IElERU1fSEFTSF9CSVRTXTsKK3N0YXRpYyBzdHJ1Y3Qg
c3BpbmxvY2sgaWRlbV9sb2NrOworCitzdGF0aWMgYm9vbCBpZGVtcG90ZW50KHN0cnVjdCBpZGVt
cG90ZW50ICp1LCBjb25zdCB2b2lkICpjb29raWUpCit7CisJaW50IGhhc2ggPSBoYXNoX3B0cihj
b29raWUsIElERU1fSEFTSF9CSVRTKTsKKwlzdHJ1Y3QgaGxpc3RfaGVhZCAqaGVhZCA9IGlkZW1f
aGFzaCArIGhhc2g7CisJc3RydWN0IGlkZW1wb3RlbnQgKmV4aXN0aW5nOworCWJvb2wgZmlyc3Q7
CisKKwl1LT5yZXQgPSAwOworCXUtPmNvb2tpZSA9IGNvb2tpZTsKKwlpbml0X2NvbXBsZXRpb24o
JnUtPmNvbXBsZXRlKTsKKworCXNwaW5fbG9jaygmaWRlbV9sb2NrKTsKKwlmaXJzdCA9IHRydWU7
CisJaGxpc3RfZm9yX2VhY2hfZW50cnkoZXhpc3RpbmcsIGhlYWQsIGVudHJ5KSB7CisJCWlmIChl
eGlzdGluZy0+Y29va2llICE9IGNvb2tpZSkKKwkJCWNvbnRpbnVlOworCQlmaXJzdCA9IGZhbHNl
OworCQlicmVhazsKKwl9CisJaGxpc3RfYWRkX2hlYWQoJnUtPmVudHJ5LCBpZGVtX2hhc2graGFz
aCk7CisJc3Bpbl91bmxvY2soJmlkZW1fbG9jayk7CisKKwlyZXR1cm4gIWZpcnN0OworfQorCisv
KgorICogV2Ugd2VyZSB0aGUgZmlyc3Qgb25lIHdpdGggJ2Nvb2tpZScgb24gdGhlIGxpc3QsIGFu
ZCB3ZSBlbmRlZAorICogdXAgY29tcGxldGluZyB0aGUgb3BlcmF0aW9uLiBXZSBub3cgbmVlZCB0
byB3YWxrIHRoZSBsaXN0LAorICogcmVtb3ZlIGV2ZXJ5Ym9keSAtIHdoaWNoIGluY2x1ZGVzIG91
cnNlbGZzIC0gZmlsbCBpbiB0aGUgcmV0dXJuCisgKiB2YWx1ZSwgYW5kIHRoZW4gY29tcGxldGUg
dGhlIG9wZXJhdGlvbi4KKyAqLworc3RhdGljIHZvaWQgaWRlbXBvdGVudF9jb21wbGV0ZShzdHJ1
Y3QgaWRlbXBvdGVudCAqdSwgaW50IHJldCkKK3sKKwljb25zdCB2b2lkICpjb29raWUgPSB1LT5j
b29raWU7CisJaW50IGhhc2ggPSBoYXNoX3B0cihjb29raWUsIElERU1fSEFTSF9CSVRTKTsKKwlz
dHJ1Y3QgaGxpc3RfaGVhZCAqaGVhZCA9IGlkZW1faGFzaCArIGhhc2g7CisJc3RydWN0IGhsaXN0
X25vZGUgKm5leHQ7CisJc3RydWN0IGlkZW1wb3RlbnQgKnBvczsKKworCXNwaW5fbG9jaygmaWRl
bV9sb2NrKTsKKwlobGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHBvcywgbmV4dCwgaGVhZCwgZW50
cnkpIHsKKwkJaWYgKHBvcy0+Y29va2llICE9IGNvb2tpZSkKKwkJCWNvbnRpbnVlOworCQlobGlz
dF9kZWwoJnBvcy0+ZW50cnkpOworCQlwb3MtPnJldCA9IHJldDsKKwkJY29tcGxldGUoJnBvcy0+
Y29tcGxldGUpOworCX0KKwlzcGluX3VubG9jaygmaWRlbV9sb2NrKTsKK30KKwogc3RhdGljIGlu
dCBpbml0X21vZHVsZV9mcm9tX2ZpbGUoc3RydWN0IGZpbGUgKmYsIGNvbnN0IGNoYXIgX191c2Vy
ICogdWFyZ3MsIGludCBmbGFncykKIHsKKwlzdHJ1Y3QgaWRlbXBvdGVudCBpZGVtOwogCXN0cnVj
dCBsb2FkX2luZm8gaW5mbyA9IHsgfTsKIAl2b2lkICpidWYgPSBOVUxMOwotCWludCBsZW47CisJ
aW50IGxlbiwgcmV0OwogCiAJaWYgKCFmIHx8ICEoZi0+Zl9tb2RlICYgRk1PREVfUkVBRCkpCiAJ
CXJldHVybiAtRUJBREY7CiAKKwlpZiAoaWRlbXBvdGVudCgmaWRlbSwgZmlsZV9pbm9kZShmKSkp
IHsKKwkJd2FpdF9mb3JfY29tcGxldGlvbigmaWRlbS5jb21wbGV0ZSk7CisJCXJldHVybiBpZGVt
LnJldDsKKwl9CisKIAlsZW4gPSBrZXJuZWxfcmVhZF9maWxlKGYsIDAsICZidWYsIElOVF9NQVgs
IE5VTEwsIFJFQURJTkdfTU9EVUxFKTsKIAlpZiAobGVuIDwgMCkgewogCQltb2Rfc3RhdF9pbmMo
JmZhaWxlZF9rcmVhZHMpOwpAQCAtMzA4Niw3ICszMTUzLDkgQEAgc3RhdGljIGludCBpbml0X21v
ZHVsZV9mcm9tX2ZpbGUoc3RydWN0IGZpbGUgKmYsIGNvbnN0IGNoYXIgX191c2VyICogdWFyZ3Ms
IGludAogCQlpbmZvLmxlbiA9IGxlbjsKIAl9CiAKLQlyZXR1cm4gbG9hZF9tb2R1bGUoJmluZm8s
IHVhcmdzLCBmbGFncyk7CisJcmV0ID0gbG9hZF9tb2R1bGUoJmluZm8sIHVhcmdzLCBmbGFncyk7
CisJaWRlbXBvdGVudF9jb21wbGV0ZSgmaWRlbSwgcmV0KTsKKwlyZXR1cm4gcmV0OwogfQogCiBT
WVNDQUxMX0RFRklORTMoZmluaXRfbW9kdWxlLCBpbnQsIGZkLCBjb25zdCBjaGFyIF9fdXNlciAq
LCB1YXJncywgaW50LCBmbGFncykKLS0gCjIuNDAuMC5yYzEuMi5nZDE1NjQ0ZmUwMgoK
--0000000000009785e105fcdf7f38--
