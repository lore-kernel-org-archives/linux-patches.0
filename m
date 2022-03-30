Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F07366
	for <patches@lists.linux.dev>; Wed, 30 Mar 2022 00:50:18 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso581165pjb.0
        for <patches@lists.linux.dev>; Tue, 29 Mar 2022 17:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eT0MeMyajG5bIz1AIsmqOI8u1ZS3KpxbDfVQyKevREE=;
        b=glosbfJnyVdJhuvX0pA9Vc69rYKOhKa1XDLiv4cPj3AhWEHTB8QprWfRPxMLonaS5l
         QDLdQYDTkqAPc4FvClEiCjxv+yjj7BZU7dBwHiB35XJsT1yT6TqGiomFk5sViaLe8+Ya
         C0P/UPVTCl0uqbr7lfPEmtT9LrDd0NyfoEmfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eT0MeMyajG5bIz1AIsmqOI8u1ZS3KpxbDfVQyKevREE=;
        b=ZYW1/m/CX++TfdxV+mxmQbP2lCOPMbBEFGXq6zdXReh03EvMbkocMsmEbMdCgAgrnL
         D4mHVqwXK04qwA71nTGFvtdYMMdBiclpgDmRaHiVe+iGFBRkaHEYwa0sB9YVz5MgfbE8
         2HHp20xeGOMsHyH0hyR1BiR0b7TnV9rGA7ybbA+C9IvaT6nwqsntu+UXK8X6njeumlyA
         NI7aTcOGsrdQdQQdwsjx7O0rU656F6P1sxlebebrSJsEs7mSlwLtdkzmDMDg8B+jYEch
         mXF5E4xljWYvwQZu/hrIbooNWZn4848Rws4XCywyoxH8BruzjkYr/xOZI8XRSO9RWpeW
         URYg==
X-Gm-Message-State: AOAM533q4BI3vZmAb3DLwddKJjcRfNKjkgl5SUgvhFLgDNNNWaOnWYlw
	cPC5y0FHK9ufX8fB5wgNnHm5myEepW3FjA==
X-Google-Smtp-Source: ABdhPJxNg9M7rZr3IAGHxXmao5fKjmdSwnqjp1hqMlC9FqastDXDrKbZklDTnnMqU6uCYhILFHGbSg==
X-Received: by 2002:a17:90a:3181:b0:1c7:6d18:391a with SMTP id j1-20020a17090a318100b001c76d18391amr2024849pjb.30.1648601417790;
        Tue, 29 Mar 2022 17:50:17 -0700 (PDT)
Received: from localhost ([2001:4479:e000:e400:e2b8:da3a:1007:145d])
        by smtp.gmail.com with ESMTPSA id a71-20020a63904a000000b00398666dcf8esm5680440pge.40.2022.03.29.17.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 17:50:17 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: konstantin@linuxfoundation.org
Cc: corbet@lwn.net,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Daniel Axtens <dja@axtens.net>,
	Emily Strickland <linux@emily.st>
Subject: Re: [PATCH] Documentation: kernel-hacking: minor edits for style
Date: Wed, 30 Mar 2022 11:50:12 +1100
Message-Id: <20220330005012.3899821-1-dja@axtens.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329195117.azs4kaflc6ksfzdh@meerkat.local>
References: <20220329195117.azs4kaflc6ksfzdh@meerkat.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Konstantin,

I agree the document could do with some love. I've got some suggestions to
make the tips a bit more useful, regardless of where we land on Rusty's
'iconic' prose.

---

Subject: [PATCH] hacking.rst: update for modern git-based workflows

The tips are fun, but they predate git. With git we do things differently.
Document something closer to what we do.

Reported-by: Emily Strickland <linux@emily.st>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 Documentation/kernel-hacking/hacking.rst | 59 +++++++++++++++++++-----
 1 file changed, 47 insertions(+), 12 deletions(-)

diff --git a/Documentation/kernel-hacking/hacking.rst b/Documentation/kernel-hacking/hacking.rst
index 55bd37a2efb0..a4f7d717de3c 100644
--- a/Documentation/kernel-hacking/hacking.rst
+++ b/Documentation/kernel-hacking/hacking.rst
@@ -723,15 +723,9 @@ Putting Your Stuff in the Kernel
 In order to get your stuff into shape for official inclusion, or even to
 make a neat patch, there's administrative work to be done:
 
--  Figure out whose pond you've been pissing in. Look at the top of the
-   source files, inside the ``MAINTAINERS`` file, and last of all in the
-   ``CREDITS`` file. You should coordinate with this person to make sure
-   you're not duplicating effort, or trying something that's already
-   been rejected.
-
-   Make sure you put your name and EMail address at the top of any files
-   you create or mangle significantly. This is the first place people
-   will look when they find a bug, or when **they** want to make a change.
+-  Read ``Documentation/process/submitting-patches.rst``. Kernel developers are
+   a picky bunch, and that document attempts to list what we do and do not like
+   in our patches.
 
 -  Usually you want a configuration option for your kernel hack. Edit
    ``Kconfig`` in the appropriate directory. The Config language is
@@ -748,15 +742,56 @@ make a neat patch, there's administrative work to be done:
    can usually just add a "obj-$(CONFIG_xxx) += xxx.o" line. The syntax
    is documented in ``Documentation/kbuild/makefiles.rst``.
 
+- Finally, re-read
+  ``Documentation/process/submitting-patches.rst``. Seriously. Do it.
+
+
+Historical Notes
+----------------
+
+These were previous tips. They've largely become outdated by the adoption of git
+in the kernel, and creation better tooling generally, but in homage to Rusty's
+iconic prose, you can still read them here in annotated form.
+
+-  Figure out whose pond you've been pissing in. Look at the top of the
+   source files, inside the ``MAINTAINERS`` file, and last of all in the
+   ``CREDITS`` file. You should coordinate with this person to make sure
+   you're not duplicating effort, or trying something that's already
+   been rejected.
+
+.. note::
+
+    Use ``scripts/get_maintainer.pl`` these days, don't try to read
+    ``MAINTAINERS`` manually. Coordinating big changes is still a good idea: use
+    a mailing list suggested by the script for this purpose. The lists should
+    have searchable archives as well.
+
+   Make sure you put your name and EMail address at the top of any files
+   you create or mangle significantly. This is the first place people
+   will look when they find a bug, or when **they** want to make a change.
+
+.. note::
+
+    With git, putting your name at the top of the file is now less useful.
+    People will do ``git log`` and ``git blame`` to if they need to find a
+    specific individual. Still put your name on new files, but only add it to
+    existing files if you've done really significant changes.
+
 -  Put yourself in ``CREDITS`` if you've done something noteworthy,
    usually beyond a single file (your name should be at the top of the
    source files anyway). ``MAINTAINERS`` means you want to be consulted
    when changes are made to a subsystem, and hear about bugs; it implies
    a more-than-passing commitment to some part of the code.
 
--  Finally, don't forget to read
-   ``Documentation/process/submitting-patches.rst`` and possibly
-   ``Documentation/process/submitting-drivers.rst``.
+.. note::
+
+    ``CREDITS`` is now more of a honour roll of former maintainers. Your
+    contribution will be immortalised in the git history, you don't need to add
+    yourself to ``CREDITS`` as well.
+
+- As well as reading ``Documentation/process/submitting-patches.rst``,
+  ``Documentation/process/submitting-drivers.rst`` is possibly useful.
+
 
 Kernel Cantrips
 ===============
-- 
2.32.0

