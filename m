Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A825E23535C;
	Wed, 12 Mar 2025 08:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741768654; cv=none; b=dp6qNk1FhWTNJSUaSG683pBu4V9hOGN+qhrh/UjNs5rr2IDqn5wSz3nGLCNODICMv2kz5Q9UVYVW5GIzOgDlJ0McG9p68a0PprMRZqWxtVAZF2hwb/xBnlcMzFg+G0NsG2nCxGf2BXPwnbyeuSGQLPLPLSEvog2GHCHSd1cjc/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741768654; c=relaxed/simple;
	bh=6q4K5GsZ6QEmn49Q5nFM9WOPyH9+FEPWdWGlyh6lWvY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nMRTfBQYms5D0cani0g93EkReSNCWiGUmWItiBOb3ET6Zs+XuymbvYxrlTNCccsl3kpOZu3ol1uINmumFgpb63DKRG3fIp2NpDIAdoxw2VMTYFke2TaYNt5IxVBxJCFrRz1GcKmjA5uL2Ow5gtZUPgsLj4bbZJYdIkbsTP4vWFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mKMlZ07O; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mKMlZ07O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WzNd/wFHRcJtHFj5hoU5K8/LPXr0tspyN5sCwLTPRNc=; b=mKMlZ07OKG4BJ0zNNlgW1zOBBG
	HAzaROKUSkQH9+LeLBhkTP0iP9VQ1XjXQvyQc4Ogx+PWnokuPl/J11IIH67eqfYIQjCTsyqYLCRbr
	fyWLQRNJ5xD8d5bYJDFNsKPzPVQRQbEECaxHhbAmqe5r5u7lQSGIKp0+PR2ObtWjefMcVzwgTWhSg
	Q6hitHABIxlZo/b/2aAUdFr/e0smjUhWHXeF4rpF6kHErVorrjlRap1isP58sYQbo5Ma+aYyH6n5C
	4UuAQBq8oVKH1NdnamCI47vPkXIqte1I3oIySXo6tsueByz5HqfFcBLHnUqjFc4pNe6L+tFUhLeLg
	zsO2hFPQ==;
Received: from [217.92.198.105] (helo=u09cd745991455d.ant.amazon.com)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsHaj-00000002KzV-2rZl;
	Wed, 12 Mar 2025 08:37:29 +0000
Message-ID: <b774454b0de171751d17c9bfb4a936a9ba2861cc.camel@infradead.org>
Subject: Re: [EXTERNAL] [PATCH 6.13 089/443] x86/kexec: Allocate PGD for
 x86_64 transition page tables separately
From: David Woodhouse <dwmw2@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ard Biesheuvel
	 <ardb@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Ingo Molnar
 <mingo@kernel.org>, Baoquan He <bhe@redhat.com>, Vivek Goyal
 <vgoyal@redhat.com>,  Dave Young <dyoung@redhat.com>, Eric Biederman
 <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>,  Sasha Levin
 <sashal@kernel.org>
Date: Wed, 12 Mar 2025 09:37:28 +0100
In-Reply-To: <2025031218-cardboard-pushcart-4211@gregkh>
References: <20250213142440.609878115@linuxfoundation.org>
	 <20250213142444.044525855@linuxfoundation.org>
	 <c4a1af46f7edcdf20274e384ec3b48781a350aaa.camel@infradead.org>
	 <2025031203-scoring-overpass-0e1a@gregkh>
	 <CAMj1kXH6oWVkUeU6+JYCuarzc5+AQxfyBzehfmLFRdKXg86qaA@mail.gmail.com>
	 <2025031218-cardboard-pushcart-4211@gregkh>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-CnyWL/9Ku9pMefDDWYaC"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-CnyWL/9Ku9pMefDDWYaC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-03-12 at 09:16 +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 12, 2025 at 08:54:52AM +0100, Ard Biesheuvel wrote:
> > On Wed, 12 Mar 2025 at 08:47, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >=20
> > > On Tue, Mar 11, 2025 at 04:45:26PM +0100, David Woodhouse wrote:
> > > > On Thu, 2025-02-13 at 15:24 +0100, Greg Kroah-Hartman wrote:
> > > > > 6.13-stable review patch.=C2=A0 If anyone has any objections, ple=
ase let me know.
> > > > >=20
> > > > > ------------------
> > > > >=20
> > > > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > > >=20
> > > > > [ Upstream commit 4b5bc2ec9a239bce261ffeafdd63571134102323 ]
> > > > >=20
> > > > > Now that the following fix:
> > > > >=20
> > > > > =C2=A0 d0ceea662d45 ("x86/mm: Add _PAGE_NOPTISHADOW bit to avoid =
updating userspace page tables")
> > > > >=20
> > > > > stops kernel_ident_mapping_init() from scribbling over the end of=
 a
> > > > > 4KiB PGD by assuming the following 4KiB will be a userspace PGD,
> > > > > there's no good reason for the kexec PGD to be part of a single
> > > > > 8KiB allocation with the control_code_page.
> > > > >=20
> > > > > ( It's not clear that that was the reason for x86_64 kexec doing =
it that
> > > > > =C2=A0 way in the first place either; there were no comments to t=
hat effect and
> > > > > =C2=A0 it seems to have been the case even before PTI came along.=
 It looks like
> > > > > =C2=A0 it was just a happy accident which prevented memory corrup=
tion on kexec. )
> > > > >=20
> > > > > Either way, it definitely isn't needed now. Just allocate the PGD
> > > > > separately on x86_64, like i386 already does.
> > > >=20
> > > > No objection (which is just as well given how late I am in replying=
)
> > > > but I'm just not sure *why*. This doesn't fix a real bug; it's just=
 a
> > > > cleanup.
> > > >=20
> > > > Does this mean I should have written my original commit message bet=
ter,
> > > > to make it clearer that this *isn't* a bugfix?
> > >=20
> > > Yes, that's why it was picked up.
> > >=20
> >=20
> > The patch has no fixes: tag and no cc:stable. The burden shouldn't be
> > on the patch author to sprinkle enough of the right keywords over the
> > commit log to convince the bot that this is not a suitable stable
> > candidate, just because it happens to apply without conflicts.
>=20
> The burden is not there to do that, this came in from the AUTOSEL stuff.
> It was sent to everyone on Jan 26:
> 	https://lore.kernel.org/r/20250126150720.961959-3-sashal@kernel.org
> so there was 1 1/2 weeks chance to say something before Sasha committed
> it to the stable queue.=C2=A0 Then it was sent out again here in the -rc
> releases for review, for anyone to object to.
>=20
> So there was 3 different times someone could have said "no, this isn't
> ok for stable inclusion" before it was merged.=C2=A0 And even if that's n=
ot
> enough, I'll be glad to revert it if it wasn't ok to be merged at any
> time afterward.

FWIW I don't think there's any need to revert it; it's fine. Just not
entirely necessary. I did see it in January but I was travelling so I
didn't get past briefly wondering *why* it was being picked up; I
thought perhaps one of the x86 maintainers had actually chosen to do
so.

If I'd *objected*, I'd have found the time to do so then.



--=-CnyWL/9Ku9pMefDDWYaC
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDMxMjA4Mzcy
OFowLwYJKoZIhvcNAQkEMSIEIHPKDC/TGZ+9RNjmu5cIpbBmOAKiarwHF2evU19QWnUwMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAjT1H1LM0dD/x
ztAc0pftqRnG7/MjOi2IiBynmV35yaYCDnqXE8D7X7nJ5MVXfSigPf5x9STmTYdKme0KcizWS3go
eu8GE2aY45eYVyqI8SMDgEHQTZsRPaCnoor0EkFwnQkL+U1SbU1E4Pw2jtZn0l2T/NZ5JxAIoPqy
pwG+O9b9RB2kUC6U66Xem1eQkw9rSWJrm27VWbSFliymv4qUQSKrZAkz7VnyHEFNrBHlPpTPi2ma
K4VT/1OtAM5e1iCNYzfDULNgv5hwVuMSDR9BlIarpag0x2zuZ4qEY7dJJK8VNMgyknmaKaNLuLFt
HtJCshKGSL1vQsldZ/Mv2tYQtVn3lZ5DlgDsLOrFZqUayNbTc9F9BUyxu/8zcsBMCk7jhwPfHpMj
Qw7drVsxg9AN8et+lgSUdNaMRPsNLZYc+/sWkz2etcdU26BEoCZ/WwvWp8g7ZWBgKNwJfxff6WT0
r2jNpFc3ROI5nu4e+Hml36kfUVbInzjvT0a2dvZaiIA8SKYSSvGHarp8UDFuLG/py5N79BZkEccS
F2s+wx3vDnyLMIovAkfpapOyWkhQgZzKdDk6tTr7SLJEBfCHC89v6RueuGPIgOXKuedBIxD1iPT/
M1esbXevWBpob7zcjWdx3Xci5ytraHIe4g5zLqt0QkmYztwP+cDQdF7nDMiU910AAAAAAAA=


--=-CnyWL/9Ku9pMefDDWYaC--
