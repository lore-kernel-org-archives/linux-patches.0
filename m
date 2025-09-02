Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE6B469D
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 06:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756796335; cv=none; b=FtUEg/R6/qWaBkCee5EJBECSd1l9rg6DWt339IBHx5k4iDzwIuWg691Fh7lQ+gYqaPUHoeRksh0N3ZleY5vEQA3Ns8CHq7yv0AzD0NjoF8kQqAeUYFDSt7cC0zyUGnhOiYn+Pei2GuZi1I/seKmo3mBXpjffNbLgJUn4NlZzkZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756796335; c=relaxed/simple;
	bh=FxyB8KmeO2NsdMIYJ6uPIuHJnw18rr2QCLh3a8/xg20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TZuutEqrVZnpxbJSANtLJcKHVI+mUv0WJp3PBA0lhdr54Qp6vfV7n/JwO3FcJCCWFhVjU0bHd7KbJxS5DgeaEvevjLEuhTk+OXHwu1PKCFIUWgi6JfaQFsGYRMFx1A1JU8oCsMzjiN7t2EjamZoasL3bM6FqMk/T5SpGNrL5naM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LydOJL9y; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LydOJL9y"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61cd6089262so7990952a12.3
        for <patches@lists.linux.dev>; Mon, 01 Sep 2025 23:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756796332; x=1757401132; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcgGJ/OYvj+YieT2Mj26UykE9RBcjh8dHLuyKc8kxcQ=;
        b=LydOJL9yZCjq+L4FRLB9xATfwNhmWPudpg//KLfzRBjchu/+lPr5um1km1g1RIaJVm
         yTv96xHbSvh0/hHigjjRGHjgrXnXripstFgAtSN6yowRstuDN2Rae+Zd3tpZFSB0awXr
         F/DyuE1bpoFF9IaJWwQ9tUQBXVREkAb9EtbaD4YZaWCLvszdWN0umIvm+dOTmzLrpTco
         yA1TFN9IwlohDoygz5TYKXKiJhHpCb7YabmWJxosQyH2vfmNTK0es65NZt9dF3jmMSsQ
         BPTYZqPNE5y0bXjWivD1bA/QN8VdA86gjEDFmVF5bwPGSKE4vpQ29hqeaW27YW2Dm7uL
         hL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756796332; x=1757401132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CcgGJ/OYvj+YieT2Mj26UykE9RBcjh8dHLuyKc8kxcQ=;
        b=JknvMZVyCZvZAAV9SekohNhlXnSqRn+FgoelqiuF3KQMIpsmhGSsYDjDrTuW84D2AI
         28Mbma2zT0NID4pupTslyxhyRoY3tpO1QGC7N2ofHHFWw3FaRTU+xv21CbOqlzZ9p66B
         jdR4PwYSJimeP2nAO8boNxuFfcXbU8o86DDqiOuMIxPEkMJkqnvdnFghtxX8LMCtnZlT
         cuHKaUsWfvdGHFY+elaPih2pzGp7d52EcZ8BaLVluWbLNhSsU35aUvdDCPmIkA2DUVPE
         YROOww1AA7/oPWNNQei/U2H45VkL9q30bhltGrYGpyIr3ogiDgU/LjY0xmfbJfR5KVrb
         +Tfg==
X-Forwarded-Encrypted: i=1; AJvYcCXVBw+a0/mzt6NyhsxL0a18Q6xIke0R8Cwfj6Y5nD2/s6R2wOFAsR9ArllSJ3CyQsYw+ntszMKo@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0YwXNJX63RcbBu5HrYc7x7JTxq3zicUdO8gZTMXd0TaELGMa/
	ZPcHvNq+QRJft7lQubsYlVWk26WymOQrm/nGjAoS1ine1H9cGC/pJ+d8rPYIrlszKf+oAu6+95O
	7bu1sjpEU4fdmegvjC51Lwm43lwykwLc=
X-Gm-Gg: ASbGnctEIO5EL6XvDLXoRGhkFnzHt2IHptAzxjtW4s4omRY1nPQEbrF6cNQwwTub7BX
	DPevZD/vsc7tJZWoj66utS9Xy5ACOVPGtl7SgjO9h22XSR2we8jMwARSdzVEfMREo7Exj9ymtoG
	9D9pxlimPMixswjo4cldGYR/M2cp3JuJEBmjxowNDqn6GaNIgu2heRIkGQtz72wbNktFn35QKpj
	xdf/VOrORigJXZgFA==
X-Google-Smtp-Source: AGHT+IHtxRdy/cLBH9rL18FC84yByLcaoc43KzkNVlknKUEcHp6Ul3SE5+4+xVW28Ki8sLRZg6VPCoBHV2tJefNOaOg=
X-Received: by 2002:a05:6402:274d:b0:61e:95b0:c95d with SMTP id
 4fb4d7f45d1cf-61e95b11582mr5639504a12.19.1756796331930; Mon, 01 Sep 2025
 23:58:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250901231457.1179748-1-rdunlap@infradead.org>
In-Reply-To: <20250901231457.1179748-1-rdunlap@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 2 Sep 2025 08:58:40 +0200
X-Gm-Features: Ac12FXz70y9An6zSkD9I5T6JyN4lQ-aLSWISxg8ShazAXP3F9zmY8IGf3i4xCAk
Message-ID: <CAOQ4uxjXvYBsW1Nb2HKaoUg1qi8Pkq1XKtQEbnAvMUGcp7LrZA@mail.gmail.com>
Subject: Re: [PATCH v2] uapi/fcntl: define RENAME_* and AT_RENAME_* macros
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, patches@lists.linux.dev, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 2, 2025 at 1:14=E2=80=AFAM Randy Dunlap <rdunlap@infradead.org>=
 wrote:
>
> Define the RENAME_* and AT_RENAME_* macros exactly the same as in
> recent glibc <stdio.h> so that duplicate definition build errors in
> both samples/watch_queue/watch_test.c and samples/vfs/test-statx.c
> no longer happen. When they defined in exactly the same way in
> multiple places, the build errors are prevented.
>
> Defining only the AT_RENAME_* macros is not sufficient since they
> depend on the RENAME_* macros, which may not be defined when the
> AT_RENAME_* macros are used.
>
> Build errors being fixed:
>
> for samples/vfs/test-statx.c:
>
> In file included from ../samples/vfs/test-statx.c:23:
> usr/include/linux/fcntl.h:159:9: warning: =E2=80=98AT_RENAME_NOREPLACE=E2=
=80=99 redefined
>   159 | #define AT_RENAME_NOREPLACE     0x0001
> In file included from ../samples/vfs/test-statx.c:13:
> /usr/include/stdio.h:171:10: note: this is the location of the previous d=
efinition
>   171 | # define AT_RENAME_NOREPLACE RENAME_NOREPLACE
> usr/include/linux/fcntl.h:160:9: warning: =E2=80=98AT_RENAME_EXCHANGE=E2=
=80=99 redefined
>   160 | #define AT_RENAME_EXCHANGE      0x0002
> /usr/include/stdio.h:173:10: note: this is the location of the previous d=
efinition
>   173 | # define AT_RENAME_EXCHANGE RENAME_EXCHANGE
> usr/include/linux/fcntl.h:161:9: warning: =E2=80=98AT_RENAME_WHITEOUT=E2=
=80=99 redefined
>   161 | #define AT_RENAME_WHITEOUT      0x0004
> /usr/include/stdio.h:175:10: note: this is the location of the previous d=
efinition
>   175 | # define AT_RENAME_WHITEOUT RENAME_WHITEOUT
>
> for samples/watch_queue/watch_test.c:
>
> In file included from usr/include/linux/watch_queue.h:6,
>                  from ../samples/watch_queue/watch_test.c:19:
> usr/include/linux/fcntl.h:159:9: warning: =E2=80=98AT_RENAME_NOREPLACE=E2=
=80=99 redefined
>   159 | #define AT_RENAME_NOREPLACE     0x0001
> In file included from ../samples/watch_queue/watch_test.c:11:
> /usr/include/stdio.h:171:10: note: this is the location of the previous d=
efinition
>   171 | # define AT_RENAME_NOREPLACE RENAME_NOREPLACE
> usr/include/linux/fcntl.h:160:9: warning: =E2=80=98AT_RENAME_EXCHANGE=E2=
=80=99 redefined
>   160 | #define AT_RENAME_EXCHANGE      0x0002
> /usr/include/stdio.h:173:10: note: this is the location of the previous d=
efinition
>   173 | # define AT_RENAME_EXCHANGE RENAME_EXCHANGE
> usr/include/linux/fcntl.h:161:9: warning: =E2=80=98AT_RENAME_WHITEOUT=E2=
=80=99 redefined
>   161 | #define AT_RENAME_WHITEOUT      0x0004
> /usr/include/stdio.h:175:10: note: this is the location of the previous d=
efinition
>   175 | # define AT_RENAME_WHITEOUT RENAME_WHITEOUT
>
> Fixes: b4fef22c2fb9 ("uapi: explain how per-syscall AT_* flags should be =
allocated")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: Alexander Aring <alex.aring@gmail.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: David Howells <dhowells@redhat.com>
> CC: linux-api@vger.kernel.org
> To: linux-fsdevel@vger.kernel.org
>
>  include/uapi/linux/fcntl.h |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> --- linux-next-20250819.orig/include/uapi/linux/fcntl.h
> +++ linux-next-20250819/include/uapi/linux/fcntl.h
> @@ -156,9 +156,12 @@
>   */
>
>  /* Flags for renameat2(2) (must match legacy RENAME_* flags). */
> -#define AT_RENAME_NOREPLACE    0x0001
> -#define AT_RENAME_EXCHANGE     0x0002
> -#define AT_RENAME_WHITEOUT     0x0004
> +# define RENAME_NOREPLACE (1 << 0)
> +# define AT_RENAME_NOREPLACE RENAME_NOREPLACE
> +# define RENAME_EXCHANGE (1 << 1)
> +# define AT_RENAME_EXCHANGE RENAME_EXCHANGE
> +# define RENAME_WHITEOUT (1 << 2)
> +# define AT_RENAME_WHITEOUT RENAME_WHITEOUT
>

This solution, apart from being terribly wrong (adjust the source to match
to value of its downstream copy), does not address the issue that Mathew
pointed out on v1 discussion [1]:

$ grep -r AT_RENAME_NOREPLACE /usr/include
/usr/include/linux/fcntl.h:#define AT_RENAME_NOREPLACE  0x0001

It's not in stdio.h at all.  This is with libc6 2.41-10

[1] https://lore.kernel.org/linux-fsdevel/aKxfGix_o4glz8-Z@casper.infradead=
.org/

I don't know how to resolve the mess that glibc has created.

Perhaps like this:

diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index f291ab4f94ebc..dde14fa3c2007 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -155,10 +155,16 @@
  * as possible, so we can use them for generic bits in the future if neces=
sary.
  */

-/* Flags for renameat2(2) (must match legacy RENAME_* flags). */
-#define AT_RENAME_NOREPLACE    0x0001
-#define AT_RENAME_EXCHANGE     0x0002
-#define AT_RENAME_WHITEOUT     0x0004
+/*
+ * The legacy renameat2(2) RENAME_* flags are conceptually also
syscall-specific
+ * flags, so it could makes sense to create the AT_RENAME_* aliases
for them and
+ * maybe later add support for generic AT_* flags to this syscall.
+ * However, following a mismatch of definitions in glibc and since no
kernel code
+ * currently uses the AT_RENAME_* aliases, we leave them undefined here.
+#define AT_RENAME_NOREPLACE    RENAME_NOREPLACE
+#define AT_RENAME_EXCHANGE     RENAME_EXCHANGE
+#define AT_RENAME_WHITEOUT     RENAME_WHITEOUT
+*/

 /* Flag for faccessat(2). */
 #define AT_EACCESS             0x200   /* Test access permitted for
