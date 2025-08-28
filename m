Received: from smtp-o-3.desy.de (smtp-o-3.desy.de [131.169.56.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AA130C604
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 12:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=131.169.56.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385298; cv=none; b=nYCoSyLp4kGiwHmpAqW0jjgM43TN1A1Q75EskBINb7xakFOV5dLQzAuHQ/vYAObivTgVeBh6xjxSsap7MVQUivtRQvu6JZj7iQpDbozMpEq+LCDjS0vurhL2xOVjCcGrug5wTOPU8im6daJsk5TvNlFvB50UHqNKvXvkihnDZbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385298; c=relaxed/simple;
	bh=NwlJER5TwN4jq9RS4wj5cl/xjNnKeNCPBoVP+zjAuNI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=YsTv9StpPJuG6F5PWq5GRAsWHI+42Udjy29JGRwU9X939jWEYQggOgCA1diTx8dkJa7SkE4Sa9gudEJ3OnXxJZ2ZNdNJrvlCvUX5FhO4SkAcIyIGb6Z4Y4cvtGB45JBzm33YZzPBz0WJGtuxIenIkdWtY8K93Y+jlfidat4RGzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=desy.de; spf=pass smtp.mailfrom=desy.de; dkim=pass (1024-bit key) header.d=desy.de header.i=@desy.de header.b=dfI+mLWu; arc=none smtp.client-ip=131.169.56.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=desy.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=desy.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=desy.de header.i=@desy.de header.b="dfI+mLWu"
Received: from smtp-o-2.desy.de (smtp-o-2.desy.de [131.169.56.155])
	by smtp-o-3.desy.de (Postfix) with ESMTP id BEF4D11F91C
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 14:48:13 +0200 (CEST)
Received: from smtp-buf-1.desy.de (smtp-buf-1.desy.de [IPv6:2001:638:700:1038::1:a4])
	by smtp-o-2.desy.de (Postfix) with ESMTP id 08A7B13F648
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 14:48:06 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp-o-2.desy.de 08A7B13F648
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=desy.de; s=default;
	t=1756385286; bh=yPEnCEUlOjZndbu8nSXz/U5gUyjQihz79sLTH6kpWqY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=dfI+mLWukAU1TF+Gnpu4XNfV4G+0fxyCdbxD+UsHsXuWBWBoExusXfTcg/o1umrPS
	 ze0sBoSfp/IywMytURRuF69gFFk8Mn0AAyffPDvIsrEWUIGy4LHvKbZOy0npbYtsia
	 ClMZkz13dET4HNDsIXhqfqJrT5Ely9fEO0WlvMiE=
Received: from smtp-m-2.desy.de (smtp-m-2.desy.de [131.169.56.130])
	by smtp-buf-1.desy.de (Postfix) with ESMTP id EE53420056;
	Thu, 28 Aug 2025 14:48:05 +0200 (CEST)
Received: from b1722.mx.srv.dfn.de (b1722.mx.srv.dfn.de [194.95.235.47])
	by smtp-m-2.desy.de (Postfix) with ESMTP id E09F616003F;
	Thu, 28 Aug 2025 14:48:05 +0200 (CEST)
Received: from smtp-intra-2.desy.de (smtp-intra-2.desy.de [131.169.56.83])
	by b1722.mx.srv.dfn.de (Postfix) with ESMTP id 991AA160058;
	Thu, 28 Aug 2025 14:48:04 +0200 (CEST)
Received: from z-mbx-2.desy.de (z-mbx-2.desy.de [131.169.55.140])
	by smtp-intra-2.desy.de (Postfix) with ESMTP id BABB620044;
	Thu, 28 Aug 2025 14:48:03 +0200 (CEST)
Date: Thu, 28 Aug 2025 14:48:03 +0200 (CEST)
From: "Mkrtchyan, Tigran" <tigran.mkrtchyan@desy.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>, patches@lists.linux.dev, 
	Trond Myklebust <trond.myklebust@hammerspace.com>, 
	Sasha Levin <sashal@kernel.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>
Message-ID: <1930989002.4608779.1756385283630.JavaMail.zimbra@desy.de>
In-Reply-To: <20250826110928.612854620@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org> <20250826110928.612854620@linuxfoundation.org>
Subject: Re: [PATCH 5.10 168/523] pNFS/flexfiles: dont attempt pnfs on fatal
 DS errors
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; 
	boundary="----=_Part_4608780_1928269810.1756385283660"
X-Mailer: Zimbra 10.1.10_GA_4785 (ZimbraWebClient - FF142 (Linux)/10.1.10_GA_4785)
Thread-Topic: pNFS/flexfiles: dont attempt pnfs on fatal DS errors
Thread-Index: eZfEBFLMzAkAKXIDN4nCBFX/JcedBg==

------=_Part_4608780_1928269810.1756385283660
Date: Thu, 28 Aug 2025 14:48:03 +0200 (CEST)
From: "Mkrtchyan, Tigran" <tigran.mkrtchyan@desy.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>, patches@lists.linux.dev, 
	Trond Myklebust <trond.myklebust@hammerspace.com>, 
	Sasha Levin <sashal@kernel.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>
Message-ID: <1930989002.4608779.1756385283630.JavaMail.zimbra@desy.de>
In-Reply-To: <20250826110928.612854620@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org> <20250826110928.612854620@linuxfoundation.org>
Subject: Re: [PATCH 5.10 168/523] pNFS/flexfiles: dont attempt pnfs on fatal
 DS errors
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 10.1.10_GA_4785 (ZimbraWebClient - FF142 (Linux)/10.1.10_GA_4785)
Thread-Topic: pNFS/flexfiles: dont attempt pnfs on fatal DS errors
Thread-Index: eZfEBFLMzAkAKXIDN4nCBFX/JcedBg==


Hi Greg,

I just got a report that the proposed fix has a bug in one of the error paths. I am
trying to fix that, so you might want to wait with the backport.

Sorry about that,
   Tigran.

----- Original Message -----
> From: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: "stable" <stable@vger.kernel.org>
> Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, patches@lists.linux.dev, "Tigran Mkrtchyan"
> <tigran.mkrtchyan@desy.de>, "Trond Myklebust" <trond.myklebust@hammerspace.com>, "Sasha Levin" <sashal@kernel.org>
> Sent: Tuesday, 26 August, 2025 13:06:18
> Subject: [PATCH 5.10 168/523] pNFS/flexfiles: dont attempt pnfs on fatal DS errors

> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
> 
> [ Upstream commit f06bedfa62d57f7b67d44aacd6badad2e13a803f ]
> 
> When an applications get killed (SIGTERM/SIGINT) while pNFS client performs a
> connection
> to DS, client ends in an infinite loop of connect-disconnect. This
> source of the issue, it that flexfilelayoutdev#nfs4_ff_layout_prepare_ds gets an
> error
> on nfs4_pnfs_ds_connect with status ERESTARTSYS, which is set by
> rpc_signal_task, but
> the error is treated as transient, thus retried.
> 
> The issue is reproducible with Ctrl+C the following script(there should be ~1000
> files in
> a directory, client should must not have any connections to DSes):
> 
> ```
> echo 3 > /proc/sys/vm/drop_caches
> 
> for i in *
> do
>   head -1 $i
> done
> ```
> 
> The change aims to propagate the nfs4_ff_layout_prepare_ds error state
> to the caller that can decide whatever this is a retryable error or not.
> 
> Signed-off-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
> Link: https://lore.kernel.org/r/20250627071751.189663-1-tigran.mkrtchyan@desy.de
> Fixes: 260f32adb88d ("pNFS/flexfiles: Check the result of nfs4_pnfs_ds_connect")
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> fs/nfs/flexfilelayout/flexfilelayout.c    | 26 ++++++++++++++---------
> fs/nfs/flexfilelayout/flexfilelayoutdev.c |  6 +++---
> 2 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c
> b/fs/nfs/flexfilelayout/flexfilelayout.c
> index a053dd05057f..57150b27c0fd 100644
> --- a/fs/nfs/flexfilelayout/flexfilelayout.c
> +++ b/fs/nfs/flexfilelayout/flexfilelayout.c
> @@ -739,14 +739,14 @@ ff_layout_choose_ds_for_read(struct pnfs_layout_segment
> *lseg,
> {
> 	struct nfs4_ff_layout_segment *fls = FF_LAYOUT_LSEG(lseg);
> 	struct nfs4_ff_layout_mirror *mirror;
> -	struct nfs4_pnfs_ds *ds;
> +	struct nfs4_pnfs_ds *ds = ERR_PTR(-EAGAIN);
> 	u32 idx;
> 
> 	/* mirrors are initially sorted by efficiency */
> 	for (idx = start_idx; idx < fls->mirror_array_cnt; idx++) {
> 		mirror = FF_LAYOUT_COMP(lseg, idx);
> 		ds = nfs4_ff_layout_prepare_ds(lseg, mirror, false);
> -		if (!ds)
> +		if (IS_ERR(ds))
> 			continue;
> 
> 		if (check_device &&
> @@ -754,10 +754,10 @@ ff_layout_choose_ds_for_read(struct pnfs_layout_segment
> *lseg,
> 			continue;
> 
> 		*best_idx = idx;
> -		return ds;
> +		break;
> 	}
> 
> -	return NULL;
> +	return ds;
> }
> 
> static struct nfs4_pnfs_ds *
> @@ -933,7 +933,7 @@ ff_layout_pg_init_write(struct nfs_pageio_descriptor *pgio,
> 	for (i = 0; i < pgio->pg_mirror_count; i++) {
> 		mirror = FF_LAYOUT_COMP(pgio->pg_lseg, i);
> 		ds = nfs4_ff_layout_prepare_ds(pgio->pg_lseg, mirror, true);
> -		if (!ds) {
> +		if (IS_ERR(ds)) {
> 			if (!ff_layout_no_fallback_to_mds(pgio->pg_lseg))
> 				goto out_mds;
> 			pnfs_generic_pg_cleanup(pgio);
> @@ -1820,6 +1820,7 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
> 	u32 idx = hdr->pgio_mirror_idx;
> 	int vers;
> 	struct nfs_fh *fh;
> +	bool ds_fatal_error = false;
> 
> 	dprintk("--> %s ino %lu pgbase %u req %zu@%llu\n",
> 		__func__, hdr->inode->i_ino,
> @@ -1827,8 +1828,10 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
> 
> 	mirror = FF_LAYOUT_COMP(lseg, idx);
> 	ds = nfs4_ff_layout_prepare_ds(lseg, mirror, false);
> -	if (!ds)
> +	if (IS_ERR(ds)) {
> +		ds_fatal_error = nfs_error_is_fatal(PTR_ERR(ds));
> 		goto out_failed;
> +	}
> 
> 	ds_clnt = nfs4_ff_find_or_create_ds_client(mirror, ds->ds_clp,
> 						   hdr->inode);
> @@ -1869,7 +1872,7 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
> 	return PNFS_ATTEMPTED;
> 
> out_failed:
> -	if (ff_layout_avoid_mds_available_ds(lseg))
> +	if (ff_layout_avoid_mds_available_ds(lseg) && !ds_fatal_error)
> 		return PNFS_TRY_AGAIN;
> 	trace_pnfs_mds_fallback_read_pagelist(hdr->inode,
> 			hdr->args.offset, hdr->args.count,
> @@ -1890,11 +1893,14 @@ ff_layout_write_pagelist(struct nfs_pgio_header *hdr,
> int sync)
> 	int vers;
> 	struct nfs_fh *fh;
> 	u32 idx = hdr->pgio_mirror_idx;
> +	bool ds_fatal_error = false;
> 
> 	mirror = FF_LAYOUT_COMP(lseg, idx);
> 	ds = nfs4_ff_layout_prepare_ds(lseg, mirror, true);
> -	if (!ds)
> +	if (IS_ERR(ds)) {
> +		ds_fatal_error = nfs_error_is_fatal(PTR_ERR(ds));
> 		goto out_failed;
> +	}
> 
> 	ds_clnt = nfs4_ff_find_or_create_ds_client(mirror, ds->ds_clp,
> 						   hdr->inode);
> @@ -1937,7 +1943,7 @@ ff_layout_write_pagelist(struct nfs_pgio_header *hdr, int
> sync)
> 	return PNFS_ATTEMPTED;
> 
> out_failed:
> -	if (ff_layout_avoid_mds_available_ds(lseg))
> +	if (ff_layout_avoid_mds_available_ds(lseg) && !ds_fatal_error)
> 		return PNFS_TRY_AGAIN;
> 	trace_pnfs_mds_fallback_write_pagelist(hdr->inode,
> 			hdr->args.offset, hdr->args.count,
> @@ -1979,7 +1985,7 @@ static int ff_layout_initiate_commit(struct
> nfs_commit_data *data, int how)
> 	idx = calc_ds_index_from_commit(lseg, data->ds_commit_index);
> 	mirror = FF_LAYOUT_COMP(lseg, idx);
> 	ds = nfs4_ff_layout_prepare_ds(lseg, mirror, true);
> -	if (!ds)
> +	if (IS_ERR(ds))
> 		goto out_err;
> 
> 	ds_clnt = nfs4_ff_find_or_create_ds_client(mirror, ds->ds_clp,
> diff --git a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
> b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
> index 4b0cdddce6eb..11777d33a85e 100644
> --- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
> +++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
> @@ -368,11 +368,11 @@ nfs4_ff_layout_prepare_ds(struct pnfs_layout_segment
> *lseg,
> 			  struct nfs4_ff_layout_mirror *mirror,
> 			  bool fail_return)
> {
> -	struct nfs4_pnfs_ds *ds = NULL;
> +	struct nfs4_pnfs_ds *ds;
> 	struct inode *ino = lseg->pls_layout->plh_inode;
> 	struct nfs_server *s = NFS_SERVER(ino);
> 	unsigned int max_payload;
> -	int status;
> +	int status = -EAGAIN;
> 
> 	if (!ff_layout_init_mirror_ds(lseg->pls_layout, mirror))
> 		goto noconnect;
> @@ -410,7 +410,7 @@ nfs4_ff_layout_prepare_ds(struct pnfs_layout_segment *lseg,
> 	ff_layout_send_layouterror(lseg);
> 	if (fail_return || !ff_layout_has_available_ds(lseg))
> 		pnfs_error_mark_layout_for_return(ino, lseg);
> -	ds = NULL;
> +	ds = ERR_PTR(status);
> out:
> 	return ds;
> }
> --
> 2.39.5

------=_Part_4608780_1928269810.1756385283660
Content-Type: application/pkcs7-signature; name=smime.p7s; smime-type=signed-data
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCAMIIH
XzCCBUegAwIBAgIQGrSZ0tLzGu9JoeeaXGroSzANBgkqhkiG9w0BAQwFADBVMQswCQYDVQQGEwJO
TDEZMBcGA1UEChMQR0VBTlQgVmVyZW5pZ2luZzErMCkGA1UEAxMiR0VBTlQgVENTIEF1dGhlbnRp
Y2F0aW9uIFJTQSBDQSA0QjAeFw0yNDEyMDQwOTQzMjZaFw0yNjAxMDMwOTQzMjZaMIGpMRMwEQYK
CZImiZPyLGQBGRMDb3JnMRYwFAYKCZImiZPyLGQBGRMGdGVyZW5hMRMwEQYKCZImiZPyLGQBGRMD
dGNzMQswCQYDVQQGEwJERTEuMCwGA1UEChMlRGV1dHNjaGVzIEVsZWt0cm9uZW4tU3luY2hyb3Ry
b24gREVTWTEoMCYGA1UEAwwfVGlncmFuIE1rcnRjaHlhbiB0aWdyYW5AZGVzeS5kZTCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBAKZ1aJleygPW8bRzYJ3VfXwfY2TxAF0QUuTk/6Bqu8Bi
UQjIgmBQ1hCzz8DVdJ8saw7p5/c1JDmVHqm2DJPwXLROKACiDdSHPf+N8PFZvxHxOqFNPeO/oJhO
jHXG1c/tL8ElfiUlMtEZYtoS60/VUz3A/4FIWP2A5s/UIOSZyCcKz3AUcAanHGEJVS8oWKQj7pNX
yjojvX4aPHzsKP+c+c/5wq08/aziRXLCekhKk+VdS8lhlS/3AL1G0VSWKj5/pOpz4ozmv44GEw9z
FAsPWuTcLXqCX993BOoWAyQDcygAsb0nQQMzx+4wlSGsI31/gKOE5ZOJ3SErWDswgzxWm8Xht/Kl
ymDHPXi8P0ohQjJrQRpJXVwD/tXDwSSbWP9jnVbtqpvLLBkNrSy6elW19nkE1ObpSPcn+be5hs1P
59Y+GPudytAQ3MOoFoNd7kxpVQoM6cdQjRHdyIDbavZrdxr33s7uqSbcI/PE8W5M0iPNnd4ip4kH
UIOdpsjk7b7kEdO4Jf9dDrz/fduAEaW+AUTfb+G42LiftUBXkANa50nOseW3tocadYOTySufN9or
IwvcQ/1uemVd83On7k8bWevfU159x28aidxv8liqJXrrT28tp/QxtGtDXjo9jdkWi/5d/9XfqQgN
IT7KH42fc3ZlaL3pLuJwEQWVtFnWUTRJAgMBAAGjggHUMIIB0DAfBgNVHSMEGDAWgBQQMuoC4vzP
6lYlVIfDmPXog9bFJDAOBgNVHQ8BAf8EBAMCBaAwCQYDVR0TBAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDAgYIKwYBBQUHAwQwRQYDVR0gBD4wPDAMBgoqhkiG90wFAgIFMA0GCyqGSIb3TAUCAwMDMA0G
CyqGSIb3TAUCAwECMA4GDCsGAQQBgcRaAgMCAjBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vY3Js
LmVudGVycHJpc2Uuc2VjdGlnby5jb20vR0VBTlRUQ1NBdXRoZW50aWNhdGlvblJTQUNBNEIuY3Js
MIGRBggrBgEFBQcBAQSBhDCBgTBPBggrBgEFBQcwAoZDaHR0cDovL2NydC5lbnRlcnByaXNlLnNl
Y3RpZ28uY29tL0dFQU5UVENTQXV0aGVudGljYXRpb25SU0FDQTRCLmNydDAuBggrBgEFBQcwAYYi
aHR0cDovL29jc3AuZW50ZXJwcmlzZS5zZWN0aWdvLmNvbTAjBgNVHREEHDAagRh0aWdyYW4ubWty
dGNoeWFuQGRlc3kuZGUwHQYDVR0OBBYEFMmhx6vILo+tVVV6rojJTwL+t2eGMA0GCSqGSIb3DQEB
DAUAA4ICAQARKKJEO1G3lIe+AA+E3pl5mNYs/+XgswX1316JYDRzBnfVweMR6IaOT7yrP+Mwhx3v
yiM8VeSVFtfyLlV6FaHAxNFo5Z19L++g/FWWAg0Wz13aFaEm0+KEp8RkB/Mh3EbSukZxUqmWCgrx
zmx+I5zlX8pLxNgrxcc1WW5l7Y7y2sci++W6wE/L7rgMuznqiBLw/qwnkXAeQrw2PIllAGwRqrwa
37kPa+naT1P0HskuBFHQSmMihB5HQl6+2Rs9M5RMW3/IlUQAqkhZQGBXmiWDivjPFKXJQnCmhQmh
76sOcSOScfzYI5xOD+ZGdBRRufkUxaXJ2G//IgkK2R8mqrFEXxBFaBMc0uMBJHKNv+FO7H6VPOe9
BD9FwfLiqWvGwKJrF11Bk/QSfWh+zCJ8JHPAi6irwQO4Xf+0xhPsxb+jBfKK3I84YMf6zsDkdDzH
lkNPhDh4xhYhEAk+L228pjTEmnbb2QVv52grZ0dbITuN+Hz2ypvLfaS8p06lrht45COlkmuIUVqp
bsc3kRt610qwXSjYcc8zeCQI0Rqnnq+0UN5T0KU7JSzUho6vaTSUG57uc7b3DkIW2Z9VpXX5xKb/
vfl++jC5JzKrbCeS+QOStpXwwaH62IUHwdfWfkvpzb8EFALEmCvu8nlT9NaqYlB/xogMH6oHBm+Y
nxmRQxWROAAAMYIDZTCCA2ECAQEwaTBVMQswCQYDVQQGEwJOTDEZMBcGA1UEChMQR0VBTlQgVmVy
ZW5pZ2luZzErMCkGA1UEAxMiR0VBTlQgVENTIEF1dGhlbnRpY2F0aW9uIFJTQSBDQSA0QgIQGrSZ
0tLzGu9JoeeaXGroSzANBglghkgBZQMEAgEFAKCBzjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yNTA4MjgxMjQ4MDRaMC0GCSqGSIb3DQEJNDEgMB4wDQYJYIZIAWUD
BAIBBQChDQYJKoZIhvcNAQELBQAwLwYJKoZIhvcNAQkEMSIEINZCD2mmSaO/R3BB29hsiRjsJp9z
ALPLHP01zrK2xxZcMDQGCSqGSIb3DQEJDzEnMCUwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MAcGBSsOAwIHMA0GCSqGSIb3DQEBCwUABIICAA2r7Wj2atsN7kbp6ffNwzA4JOo9F+ifcN6FQVSo
RTbGaqOabAPHhkCmCMwyyHFhyEEYqoh07Kc47gntk7Mi/ci9X0YTZfJ4VXn3TPOSaTy4HThVewQ+
yQPvAOqsQx1o0MX6a3V2ybrdg3k5V96XklknqRakHrnFwgDpG119ruBX5CV9qa2q+qIs2PeKgOxE
KboB0IRMTfojYatPYyap0/Y/aUFsGhA+d2OL1zlw8ozZvKPmZm+ShmBH8eJdZGy0U43ugi9Iseze
dvYlwDsLq2uCPtnMtlYPxdwWSLMN2eJr7B/RRpuS5AbOps/A1Yz4yXKW5KlfFUobO11WoPUd5c9v
2oKBLPv8usSyHzAJTCRuVCwNAQ+07/T9yYM+RO3trRBN8R894P0npf09cAxr/60KItl89cOmCr+Z
jYkPdUljV6DbOggmwfp7kVz1sMud6vYypOggvvAGlb0VJ2woAvZuM7FCRAFbh5p1w2Y8vfUZyWsn
/K6KSHUHHBuDFpz1SP7SwGZLugwHL4nqhRcvG+iOqRlAbVxuxsLTAPdzZbkXC8AUg5KLAvomNrwP
+B10bwboWo/U1R1VGUAeJZkiiMUGx2yOOaC5no/PuBHH4o+fnoIXIGe+URGSVu8WccItmP04StiS
8Pjc26wjEJtIUbt2DpmhqUyi7DmznAsvfKZIAAAAAAAA
------=_Part_4608780_1928269810.1756385283660--
