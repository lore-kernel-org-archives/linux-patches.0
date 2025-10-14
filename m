Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D5C15B0EC
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760469167; cv=none; b=WPdjilQ0g3vtUz5IMZLT9NrdSzajatGJ3KHSqfc6EvuJqXncrj6KegAWhfxHcOAx3wvMJT9LuJ/UpwpjJjurro6P6et+riKoFIQLMS4EJ4EuYFej/aIcqQW9HUHNpiEYD/N7j+yhVIjgvdU0KtcHQkdGcOhFaVz7Ow4qcT62xOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760469167; c=relaxed/simple;
	bh=O/CBH87Cuu2JnpiuuGV3gnN7vJ+9ZahquW7HlbJbW1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=geYfoulnX+yNgIhfCHASLit61t1o1+IdMaqXaubKp8TQYSS4zm1znu94/9agWTIQjI61gUfvgLe0kBKT5DA3Z+qyi9tuQIqjcQZHImkOUMTguG3UPHYMCoILpAbJFQ19K0oW/iT9ULWk/TrLHypiFn2pfrSdP9bWVw9GJ4HgX0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Myda6Iud; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Myda6Iud"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-7f7835f4478so57125336d6.1
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 12:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760469165; x=1761073965; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hj4KdecgoGHGYTc5Fn92jUDm+U1qN1I8QFfxys6tF+E=;
        b=Myda6IudZt3pijhUZFp4CqASATgl9BmoGFauBTI8Ik0TSn6MfEZfgOrM+6wd3TaCoB
         P5JuJsSQWFnSvMIlw4/OqinjNDj6GCNfIoQefZDOzqKHw1ND26PaeBaqjkjdto5D8Ace
         r8JZQknoykx6hvKnC4z7mGJ61kObs0WxggjGFG9Ku0PUB2ccvUxWLa/eeXUpVfPB5tIA
         XQM8vvHwECpVXRPut3Hw76Lx4w5GhJezI8WYdUxI7K9rVhArlsftajQwTYcO6sSjgo5E
         mYdqtyrfqky57S0iwbS0pvWW0adJM+LguoPz0frziudsjp2R4G9hOVffriWSXZVCsrUl
         oy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760469165; x=1761073965;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hj4KdecgoGHGYTc5Fn92jUDm+U1qN1I8QFfxys6tF+E=;
        b=nONkHshZ0vIi/YsDEQR2XnU/ISCeTIYeQ/mb0Ab7myVa8qQuQPgqXYGIHKvHCF6m/e
         sAebPQQYOEaRJlQrHA5Sa09RKFuEcQioCmkgNdRbvBlLNuD9Rxa1VaZXj0NAdwNqd6Uq
         58lLmtQFU5nUcx0sxvWGHzyxGst7gxwcXrfijxaE9oLiVaHu+EbOqRXKSYMGkxrt8/l8
         1iycd01HcB8zEWmNA+2OzTtEQUTR1fQdI7g8sTDbK40XXGF2fRUBVz6JyVGgBRuA+ymx
         AHbAjDOJM4PKycWSy83MFwmWs9ZBtoNkhErspAnqzV20fBGHO/xcoO7E1DtQVM3t34Ex
         lMEg==
X-Forwarded-Encrypted: i=1; AJvYcCWTJLSCoANE1ywVzkpbsW+1cot/dBluOe0JE65d5T/fRUg5sqPuNfWMBKkzgp6P2Dfz9+PHY85h@lists.linux.dev
X-Gm-Message-State: AOJu0Yycf8D9Bf9aSWqZxuE4ei8ljBk4GY4+QtrlXhvsmYrXV1M9k7j1
	Ud1p9ZYqjOgAY4dMnWw5qcENGA4uFqmOdkvkotTFPn8ni1FbzCZK9iUTDyafNQyKPvgUxfatiOZ
	gaClLWpCBuX+ziyrZpjIE42+HW5JQ57o=
X-Gm-Gg: ASbGnctOk5K2gmPMHb2fO63yH9bbYi8iSFC7eHo4HynbHqNoM0ipjpKaHsbNjA6SZQ6
	8OxF2m2J7oZgZiQr5QSUh0R441WaeCR+AcSWYBd+UImZX8jAqfZCLSLHolXRjCWNLCTQwPuWpb5
	hRR2M+JrWiheZIU/mYxOb7IZ3lWqCwpl6h6xqdMFyyZLaGmG4LipFr2fe9RqyjIGUDbhAC+z7WH
	BCBgA7QDrig7wltyv5hsjxdkkw+UwSiFQYxJFpXs7QdQQgWNYs/KQ3O+k/oiQZxUQlNrYnH+Abb
	F0Sow4hrt3U+ZLlZDoKRRW6jP+q7bV3tQ77TeqeE2sc/TFhD5HmPlVqCRiklMhmgPxFZ1UD75BJ
	VcqnVr79VT90r4SoTORDOZDspH80Dxl+NzdqLDHg=
X-Google-Smtp-Source: AGHT+IGVnLqJpoAZcGkUlBY7oBpr7+xLff+kKqWhWi8JYLrzCEMQGNtSYRJnnKTVONKAwpF6Xdp30jZhS5ZxqaNWFFo=
X-Received: by 2002:a05:6214:f6d:b0:70f:5a6d:a253 with SMTP id
 6a1803df08f44-87b2ef44013mr355883666d6.49.1760469164911; Tue, 14 Oct 2025
 12:12:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251014-smb-client-fix-wformat-32b-parse_dfs_referrals-v1-1-47fa7db66b71@kernel.org>
In-Reply-To: <20251014-smb-client-fix-wformat-32b-parse_dfs_referrals-v1-1-47fa7db66b71@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Oct 2025 14:12:32 -0500
X-Gm-Features: AS18NWA3bxi7uC4cjWWZ93Qyu_Sqb3TU4Fwo7i25Q_1DJKLVcEl20vSn3Vb4mSs
Message-ID: <CAH2r5mtcJJ+_x2dQ3UkVFWd4+YapHXJFWFcxs5ErU+u8kncWsA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Fix format specifiers for size_t in parse_dfs_referrals()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Eugene Korenevsky <ekorenevsky@aliyun.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Ccm Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, patches@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000369f240641232bf3"

--000000000000369f240641232bf3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Nathan,
Good catch.  Have updated the patch with your change (rather than
having two patches) and added a Suggested-by.  If you want a
Reviewed-by or Acked-by let me know.

Updated patch attached.


On Tue, Oct 14, 2025 at 1:33=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> When building for 32-bit platforms, for which 'size_t' is
> 'unsigned int', there are a couple instances of -Wformat:
>
>   fs/smb/client/misc.c:922:25: error: format specifies type 'unsigned lon=
g' but the argument has type 'unsigned int' [-Werror,-Wformat]
>     921 |                          "%s: header is malformed (size is %u, =
must be %lu)\n",
>         |                                                                =
        ~~~
>         |                                                                =
        %u
>     922 |                          __func__, rsp_size, sizeof(*rsp));
>         |                                              ^~~~~~~~~~~~
>   fs/smb/client/misc.c:940:5: error: format specifies type 'unsigned long=
' but the argument has type 'unsigned int' [-Werror,-Wformat]
>     938 |                          "%s: malformed buffer (size is %u, mus=
t be at least %lu)\n",
>         |                                                                =
              ~~~
>         |                                                                =
              %u
>     939 |                          __func__, rsp_size,
>     940 |                          sizeof(*rsp) + *num_of_nodes * sizeof(=
REFERRAL3));
>         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~
>
> Use the proper 'size_t' format specifier, '%zu', to clear up these
> warnings.
>
> Cc: stable@vger.kernel.org
> Fixes: c1047752ed9f ("cifs: parse_dfs_referrals: prevent oob on malformed=
 input")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Feel free to squash this into the original change to make backporting
> easier. I included the tags in case rebasing was not an option.
> ---
>  fs/smb/client/misc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index 987f0ca73123..e10123d8cd7d 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -918,7 +918,7 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp,=
 u32 rsp_size,
>
>         if (rsp_size < sizeof(*rsp)) {
>                 cifs_dbg(VFS | ONCE,
> -                        "%s: header is malformed (size is %u, must be %l=
u)\n",
> +                        "%s: header is malformed (size is %u, must be %z=
u)\n",
>                          __func__, rsp_size, sizeof(*rsp));
>                 rc =3D -EINVAL;
>                 goto parse_DFS_referrals_exit;
> @@ -935,7 +935,7 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp,=
 u32 rsp_size,
>
>         if (sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3) > rsp_size) =
{
>                 cifs_dbg(VFS | ONCE,
> -                        "%s: malformed buffer (size is %u, must be at le=
ast %lu)\n",
> +                        "%s: malformed buffer (size is %u, must be at le=
ast %zu)\n",
>                          __func__, rsp_size,
>                          sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3)=
);
>                 rc =3D -EINVAL;
>
> ---
> base-commit: 4e47319b091f90d5776efe96d6c198c139f34883
> change-id: 20251014-smb-client-fix-wformat-32b-parse_dfs_referrals-189b8c=
6fdf75
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>


--=20
Thanks,

Steve

--000000000000369f240641232bf3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-parse_dfs_referrals-prevent-oob-on-malformed-in.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-parse_dfs_referrals-prevent-oob-on-malformed-in.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mgqxvjv90>
X-Attachment-Id: f_mgqxvjv90

RnJvbSA3ZjBmNTRkZmMzMTA2M2E4ZWE4YzBkMTAzNGNjOTBhZTY2MTQwM2ZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFdWdlbmUgS29yZW5ldnNreSA8ZWtvcmVuZXZza3lAYWxpeXVu
LmNvbT4KRGF0ZTogTW9uLCAxMyBPY3QgMjAyNSAyMTozOTozMCArMDMwMApTdWJqZWN0OiBbUEFU
Q0hdIGNpZnM6IHBhcnNlX2Rmc19yZWZlcnJhbHM6IHByZXZlbnQgb29iIG9uIG1hbGZvcm1lZCBp
bnB1dAoKTWFsaWNpb3VzIFNNQiBzZXJ2ZXIgY2FuIHNlbmQgaW52YWxpZCByZXBseSB0byBGU0NU
TF9ERlNfR0VUX1JFRkVSUkFMUwoKLSByZXBseSBzbWFsbGVyIHRoYW4gc2l6ZW9mKHN0cnVjdCBn
ZXRfZGZzX3JlZmVycmFsX3JzcCkKLSByZXBseSB3aXRoIG51bWJlciBvZiByZWZlcnJhbHMgc21h
bGxlciB0aGFuIE51bWJlck9mUmVmZXJyYWxzIGluIHRoZQpoZWFkZXIKClByb2Nlc3Npbmcgb2Yg
c3VjaCByZXBsaWVzIHdpbGwgY2F1c2Ugb29iLgoKUmV0dXJuIC1FSU5WQUwgZXJyb3Igb24gc3Vj
aCByZXBsaWVzIHRvIHByZXZlbnQgb29iLXMuCgpTaWduZWQtb2ZmLWJ5OiBFdWdlbmUgS29yZW5l
dnNreSA8ZWtvcmVuZXZza3lAYWxpeXVuLmNvbT4KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcK
U3VnZ2VzdGVkLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0aGFuQGtlcm5lbC5vcmc+CkFja2Vk
LWJ5OiBQYXVsbyBBbGNhbnRhcmEgKFJlZCBIYXQpIDxwY0BtYW5ndWViaXQub3JnPgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21i
L2NsaWVudC9taXNjLmMgfCAxNyArKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDE3
IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L21pc2MuYyBiL2ZzL3Nt
Yi9jbGllbnQvbWlzYy5jCmluZGV4IGRkYTZkZWNlODAyYS4uZTEwMTIzZDhjZDdkIDEwMDY0NAot
LS0gYS9mcy9zbWIvY2xpZW50L21pc2MuYworKysgYi9mcy9zbWIvY2xpZW50L21pc2MuYwpAQCAt
OTE2LDYgKzkxNiwxNCBAQCBwYXJzZV9kZnNfcmVmZXJyYWxzKHN0cnVjdCBnZXRfZGZzX3JlZmVy
cmFsX3JzcCAqcnNwLCB1MzIgcnNwX3NpemUsCiAJY2hhciAqZGF0YV9lbmQ7CiAJc3RydWN0IGRm
c19yZWZlcnJhbF9sZXZlbF8zICpyZWY7CiAKKwlpZiAocnNwX3NpemUgPCBzaXplb2YoKnJzcCkp
IHsKKwkJY2lmc19kYmcoVkZTIHwgT05DRSwKKwkJCSAiJXM6IGhlYWRlciBpcyBtYWxmb3JtZWQg
KHNpemUgaXMgJXUsIG11c3QgYmUgJXp1KVxuIiwKKwkJCSBfX2Z1bmNfXywgcnNwX3NpemUsIHNp
emVvZigqcnNwKSk7CisJCXJjID0gLUVJTlZBTDsKKwkJZ290byBwYXJzZV9ERlNfcmVmZXJyYWxz
X2V4aXQ7CisJfQorCiAJKm51bV9vZl9ub2RlcyA9IGxlMTZfdG9fY3B1KHJzcC0+TnVtYmVyT2ZS
ZWZlcnJhbHMpOwogCiAJaWYgKCpudW1fb2Zfbm9kZXMgPCAxKSB7CkBAIC05MjUsNiArOTMzLDE1
IEBAIHBhcnNlX2Rmc19yZWZlcnJhbHMoc3RydWN0IGdldF9kZnNfcmVmZXJyYWxfcnNwICpyc3As
IHUzMiByc3Bfc2l6ZSwKIAkJZ290byBwYXJzZV9ERlNfcmVmZXJyYWxzX2V4aXQ7CiAJfQogCisJ
aWYgKHNpemVvZigqcnNwKSArICpudW1fb2Zfbm9kZXMgKiBzaXplb2YoUkVGRVJSQUwzKSA+IHJz
cF9zaXplKSB7CisJCWNpZnNfZGJnKFZGUyB8IE9OQ0UsCisJCQkgIiVzOiBtYWxmb3JtZWQgYnVm
ZmVyIChzaXplIGlzICV1LCBtdXN0IGJlIGF0IGxlYXN0ICV6dSlcbiIsCisJCQkgX19mdW5jX18s
IHJzcF9zaXplLAorCQkJIHNpemVvZigqcnNwKSArICpudW1fb2Zfbm9kZXMgKiBzaXplb2YoUkVG
RVJSQUwzKSk7CisJCXJjID0gLUVJTlZBTDsKKwkJZ290byBwYXJzZV9ERlNfcmVmZXJyYWxzX2V4
aXQ7CisJfQorCiAJcmVmID0gKHN0cnVjdCBkZnNfcmVmZXJyYWxfbGV2ZWxfMyAqKSAmKHJzcC0+
cmVmZXJyYWxzKTsKIAlpZiAocmVmLT5WZXJzaW9uTnVtYmVyICE9IGNwdV90b19sZTE2KDMpKSB7
CiAJCWNpZnNfZGJnKFZGUywgIlJlZmVycmFscyBvZiBWJWQgdmVyc2lvbiBhcmUgbm90IHN1cHBv
cnRlZCwgc2hvdWxkIGJlIFYzXG4iLAotLSAKMi40OC4xCgo=
--000000000000369f240641232bf3--
