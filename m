Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625879;
	b=ynCOqP6s7mt3klcVVA29O4oMkKOGtCeW3eCPGtaH2vwDfd/ESNSMOFT7MPxoaEwnfwOV
	 Ei0HG4TiLh+CFpZ6OQmg2zEABJvx2ljoohsBEwEMmcS0PLgVb/NQc0WRYEYAL0cs4Ommy
	 Hl16M69hAcTOX9ZvMAKsm2V+JWmKB1mWsos7ZO4uPqxU3ej9B3i9E1hWl4IYRhUAaDCCC
	 Vb+BoOuCkJb8WaK3MTyTdc+Dvqmv5MCx/Y5tuBu0UNhvZmmI10hoXL+Wk5sYbGGCAOQ4p
	 Oe/knBnzuoDT7vmSsD6XVIM2cyRcBEW1l6upMqR05dYdUL/vGzvgEqEO4swjhm72xOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3UXdhcuWUJsLHT96nTapKyF/NfGfKKUpXq0irDBLEkk=;
	b=i8Nf+DQ194jKZZNjUfNE33zylhGPvBnHTVVqJVcLvx/BegETHFfgKWPP6Tqvw57QTDM3
	 khiYFowwWUWhhS8ia2PBmAAcimKf4YsSzDqc3FJ8K2QhzrlpTJGuEjZMZTafEMr4JNHc1
	 ad9Lo7GO9/fqZK1U+JROefB/U55gbcchJAp4piJ9V+4N6ia8dXZHmryr7Y0ahiD7KtW6o
	 /icSPNkrfhcQOSOuIXbMudiqY71lgkV08TqvcT7grzSfX78V7kuLE6jtCC5jr0BtV9t4n
	 3bwFtfa0bjwgaRH7mz0bqPf98XeFJDRx/1CvbS3NIThVO2tJKKStv1lbMTYftVloTNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PHKyBfAg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B588A606A321;
	Wed, 25 Nov 2026 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PHKyBfAg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9431F000C6;
	Wed, 25 Nov 2026 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625879;
	bh=3UXdhcuWUJsLHT96nTapKyF/NfGfKKUpXq0irDBLEkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHKyBfAga8Q+mSlUKs932XCiosZFMu96J/V8wKZfsg1bayRaywm2zvogCKZKCZ707
	 8kIXfTcB2joTyExnoKA65ik4yyDlY+Z1ZeNTqMXYEVgnNNUfHSakZdJW2Vq+K4q6qo
	 K5n9ZfmcyNs0AYt4E+CrKfbUL/AjhM8mzTUF60c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 615/816] fs/adfs: bound directory entry name length in adfs_fplus_getnext()
Date: Wed, 25 Nov 2026 15:36:03 +0100
Message-ID: <20261125143903.416323338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit ebf5025b0d989f95542fc9da899b7de2fec499f2 upstream.

adfs_fplus_getnext() reads the per-entry name length bigdirobnamelen
straight from the on-disk big directory and passes it to
adfs_dir_copyfrom() as the copy length into obj->name[], a fixed
ADFS_MAX_NAME_LEN (260) byte buffer.  adfs_dir_copyfrom() only bounds
the copy against the number of directory buffers, not the size of the
destination, so a crafted image with bigdirobnamelen larger than the
buffer overflows the stack-allocated object_info::name that
adfs_fplus_iterate() passes in.

adfs_object_fixup() may additionally append a four byte ",xyz" filetype
suffix, so the accepted length must also leave room for that.

The old-style directory parser (dir_f.c) already clamps names to
ADFS_F_NAME_LEN, and adfs_fplus_validate_header() validates the header
name fields, but the per-entry name length in the big directory format
was never checked.  Reject over-long entries, using -EIO as elsewhere
in this file for a corrupt big directory.

Reported-by: Hyungjung Joo <jhj140711@gmail.com>
Closes: https://lore.kernel.org/all/CAP_j_b9BqyQrk3D5nj6RSa=eGcs2HkRYsWc3WdXeXp9O3=z4nQ@mail.gmail.com/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260715115231.1585166-1-sammiee5311@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/adfs/dir_fplus.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/adfs/dir_fplus.c
+++ b/fs/adfs/dir_fplus.c
@@ -192,6 +192,8 @@ adfs_fplus_getnext(struct adfs_dir *dir,
 	obj->indaddr  = le32_to_cpu(bde.bigdirindaddr);
 	obj->attr     = le32_to_cpu(bde.bigdirattr);
 	obj->name_len = le32_to_cpu(bde.bigdirobnamelen);
+	if (obj->name_len > ADFS_MAX_NAME_LEN - 4)	/* leave room for ,xyz suffix */
+		return -EIO;
 
 	offset = adfs_fplus_offset(h, le32_to_cpu(h->bigdirentries));
 	offset += le32_to_cpu(bde.bigdirobnameptr);


