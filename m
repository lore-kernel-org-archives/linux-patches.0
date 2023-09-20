Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA2F3CCE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 19:13:30 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1c1e3a4a06fso977345ad.3
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695237209; x=1695842009; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MvQvJejvv/JyR5w5hxlhwEeijWF4kg5buSYDY153wM8=;
        b=ZlvUIILX3wt69DHyPANZkhT/jlONgOMBv9bd4T1wy6uuZkPsrBY6SBVqI1L8Hb79yB
         qeaDJFt7s+ykE21iYSfd2ys28ngpyoAukxXIk9dhxaBJ9tfcpi3cFWKFQo4/iLZPghj4
         JtJNe/WcNiXOlt3za0Ut7eIt7pBKaa2TeFZ3uqKDB5G81/ZJnue7FHrmADeC5o9rkH00
         FcaoqnG7/4bYEn2/01N/ChhRQ2Pj2vfWTXUwW+yPW63m56INxrkpH4T30DS/alpRK/jV
         8tSMdefgoqke7uZ3xuPpagvkQZgFaCBjFG75dWvL2bFrfkD9MJUTcjnDzNdJ+URsmAId
         LGDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695237209; x=1695842009;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MvQvJejvv/JyR5w5hxlhwEeijWF4kg5buSYDY153wM8=;
        b=cNwWA4Hulapy7Lp2WV9yZPVq8nVghngo0QafF+GeNJUl5U/KXhKTY7zgxU3MFPnaUs
         /Pn6ChfpfSwvlXL5p6NPA/k7jkG8c7LIBzKtMn1APTQhZ/I6/jtOh2Y63sXKpEiM22E+
         h7au9NXgF2D1z9jiSKkI8DzVTs9sGcdOZ2gN0m5NptFnE67J4LxYxrCcAwgnA5SjK5Bh
         1zXCB32th3k/SANXrKLtoYf8ohg94tI2dCD9qgPP6yszK4yKurSXwLwRdDjpsBcsWsQM
         wFV1ZRZVYe5aH7iSFmAdU532PUfTPdrlsl3SdwqrSh5w4nWTAvPZuy62P31XAlYXhe4X
         Hr3A==
X-Gm-Message-State: AOJu0Yz+ulkEgRFdO0dVQo+DCzVBihSmZuJa4dUkxAEEwcg3SmdH6syk
	PsKmRcWsDnioI1/76OyfeJ4=
X-Google-Smtp-Source: AGHT+IG3IRpXbiPviocPsFARPN84Bklbi5ohm2JoGYKzWZPQrZhkvLD9B9pT+Xh28LF7mj5eRbufog==
X-Received: by 2002:a17:903:11d1:b0:1c1:e7b2:27af with SMTP id q17-20020a17090311d100b001c1e7b227afmr3663953plh.57.1695237209254;
        Wed, 20 Sep 2023 12:13:29 -0700 (PDT)
Received: from westworld (209-147-138-147.nat.asu.edu. [209.147.138.147])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902654200b001c43307f87asm10324192pln.91.2023.09.20.12.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 12:13:28 -0700 (PDT)
Date: Wed, 20 Sep 2023 12:13:25 -0700
From: Kyle Zeng <zengyhkyle@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.10 000/406] 5.10.195-rc1 review
Message-ID: <ZQtEVR+Vc6CD6iUG@westworld>
References: <20230917191101.035638219@linuxfoundation.org>
 <07a04540-554c-4394-1e79-46ea665f8c03@roeck-us.net>
 <2023092009-angriness-sank-ae4f@gregkh>
 <27f978f3-11ca-6054-5160-ab66d4c918bc@roeck-us.net>
 <8457ff12-c28b-898b-3f12-97aa12ce6716@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C+MjqotaCJLWzlak"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8457ff12-c28b-898b-3f12-97aa12ce6716@gmail.com>


--C+MjqotaCJLWzlak
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 20, 2023 at 10:01:55AM -0700, Florian Fainelli wrote:
> On 9/20/23 08:18, Guenter Roeck wrote:
> > On 9/20/23 01:11, Greg Kroah-Hartman wrote:
> > > On Tue, Sep 19, 2023 at 09:57:25PM -0700, Guenter Roeck wrote:
> > > > On 9/17/23 12:07, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 5.10.195 release.
> > > > > There are 406 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > 
> > > > chromeos-5.10 locks up in configfs_lookup() after the merge of
> > > > v5.10.195.
> > > > 
> > > > I am a bit puzzled because I see
> > > > 
> > > > c709c7ca020a configfs: fix a race in configfs_lookup()
> > > > 
> > > > in v5.10.195 but not in the list of commits below. I guess I must be
> > > > missing something.
> > > 
> > > It was part of the big patchset, it was posted here:
> > >     https://lore.kernel.org/r/20230917191101.511939651@linuxfoundation.org
> > > 
> > > Not hidden at all :)
> > > 
> > > and was submitted here:
> > >     https://lore.kernel.org/r/ZPOZFHHA0abVmGx+@westworld
> > > 
> > > > Either case, the code now looks as follows.
> > > > 
> > > > configfs_lookup()
> > > > {
> > > >      ...
> > > >      spin_lock(&configfs_dirent_lock);
> > > >      ...
> > > >          err = configfs_attach_attr(sd, dentry);
> > > >      ...
> > > >      spin_unlock(&configfs_dirent_lock);
> > > >      ...
> > > > }
> > > > 
> > > > and
> > > > 
> > > > configfs_attach_attr(...)
> > > > {
> > > >      ...
> > > >      spin_lock(&configfs_dirent_lock);
> > > >      ...
> > > > }
> > > > 
> > > > which unless it is way too late here and I really need to go to sleep
> > > > just won't work.
> > > 
> > > Kyle, you did the backport, any comments?
> > > 
> > 
> > After a good night sleep, the code still looks wrong to me. Reverting
> > the offending patch in chromeos-5.10 solved the problem there.
> > That makes me suspect that no one actually tests configfs.
> 
> Humm indeed, looking at our testing we don't have our USB devices being
> tested which would exercise configfs since we switch the USB device between
> different configurations (mass storage, serial, networking etc.). Let me see
> about adding that so we get some coverage.
> -- 
> Florian
> 

Sorry for the wrong patch. My intention was to backport c42dd069be8dfc9b2239a5c89e73bbd08ab35de0
to v5.10 to avoid a race condition triggered in my test. I tested the
patch with my PoC program and made sure it won't trigger the crash. But
I didn't notice that it could hang the kernel.
I sincerely apologize for the mistake.

My new proposed patch backports both
c42dd069be8dfc9b2239a5c89e73bbd08ab35de0 and d07f132a225c013e59aa77f514ad9211ecab82ee.
I made sure it does not trigger the race condition anymore.
Can anyone having access to more comprehensive tests please check whether it works?

Also, I'm not sure whether it is OK or how to backport two patches in
one patch. Please advise on how to do it properly.

The crash triggering PoC program is also attached.

Thanks,
Kyle Zeng

--C+MjqotaCJLWzlak
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 12388ed4faa5..43093c218628 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -55,7 +55,7 @@ static void configfs_d_iput(struct dentry * dentry,
 		/*
 		 * Set sd->s_dentry to null only when this dentry is the one
 		 * that is going to be killed.  Otherwise configfs_d_iput may
-		 * run just after configfs_attach_attr and set sd->s_dentry to
+		 * run just after configfs_lookup and set sd->s_dentry to
 		 * NULL even it's still in use.
 		 */
 		if (sd->s_dentry == dentry)
@@ -428,44 +428,13 @@ static void configfs_remove_dir(struct config_item * item)
 	dput(dentry);
 }
 
-
-/* attaches attribute's configfs_dirent to the dentry corresponding to the
- * attribute file
- */
-static int configfs_attach_attr(struct configfs_dirent * sd, struct dentry * dentry)
-{
-	struct configfs_attribute * attr = sd->s_element;
-	struct inode *inode;
-
-	spin_lock(&configfs_dirent_lock);
-	dentry->d_fsdata = configfs_get(sd);
-	sd->s_dentry = dentry;
-	spin_unlock(&configfs_dirent_lock);
-
-	inode = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG);
-	if (IS_ERR(inode)) {
-		configfs_put(sd);
-		return PTR_ERR(inode);
-	}
-	if (sd->s_type & CONFIGFS_ITEM_BIN_ATTR) {
-		inode->i_size = 0;
-		inode->i_fop = &configfs_bin_file_operations;
-	} else {
-		inode->i_size = PAGE_SIZE;
-		inode->i_fop = &configfs_file_operations;
-	}
-	d_add(dentry, inode);
-	return 0;
-}
-
 static struct dentry * configfs_lookup(struct inode *dir,
 				       struct dentry *dentry,
 				       unsigned int flags)
 {
 	struct configfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
 	struct configfs_dirent * sd;
-	int found = 0;
-	int err;
+	struct inode *inode = NULL;
 
 	/*
 	 * Fake invisibility if dir belongs to a group/default groups hierarchy
@@ -475,36 +444,39 @@ static struct dentry * configfs_lookup(struct inode *dir,
 	 * not complete their initialization, since the dentries of the
 	 * attributes won't be instantiated.
 	 */
-	err = -ENOENT;
 	if (!configfs_dirent_is_ready(parent_sd))
-		goto out;
+		return ERR_PTR(-ENOENT);
 
+	spin_lock(&configfs_dirent_lock);
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
-		if (sd->s_type & CONFIGFS_NOT_PINNED) {
-			const unsigned char * name = configfs_get_name(sd);
+		if ((sd->s_type & CONFIGFS_NOT_PINNED) &&
+		    !strcmp(configfs_get_name(sd), dentry->d_name.name)) {
+			struct configfs_attribute *attr = sd->s_element;
+			umode_t mode = (attr->ca_mode & S_IALLUGO) | S_IFREG;
 
-			if (strcmp(name, dentry->d_name.name))
-				continue;
+			dentry->d_fsdata = configfs_get(sd);
+			sd->s_dentry = dentry;
+			spin_unlock(&configfs_dirent_lock);
 
-			found = 1;
-			err = configfs_attach_attr(sd, dentry);
-			break;
+			inode = configfs_create(dentry, mode);
+			if (IS_ERR(inode)) {
+				configfs_put(sd);
+				return ERR_CAST(inode);
+			}
+			if (sd->s_type & CONFIGFS_ITEM_BIN_ATTR) {
+				inode->i_size = 0;
+				inode->i_fop = &configfs_bin_file_operations;
+			} else {
+				inode->i_size = PAGE_SIZE;
+				inode->i_fop = &configfs_file_operations;
+			}
+			goto done;
 		}
 	}
-
-	if (!found) {
-		/*
-		 * If it doesn't exist and it isn't a NOT_PINNED item,
-		 * it must be negative.
-		 */
-		if (dentry->d_name.len > NAME_MAX)
-			return ERR_PTR(-ENAMETOOLONG);
-		d_add(dentry, NULL);
-		return NULL;
-	}
-
-out:
-	return ERR_PTR(err);
+	spin_unlock(&configfs_dirent_lock);
+done:
+	d_add(dentry, inode);
+	return NULL;
 }
 
 /*

--C+MjqotaCJLWzlak
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="poc.c"

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int main(void)
{
	int fd = open("/sys/kernel/config", 0);

	if(!fork()) {
		while(1) lseek(fd, SEEK_CUR, 1);
	}
	while(1) unlinkat(fd, "file", 0);

	return 0;
}

--C+MjqotaCJLWzlak--
