Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061694;
	b=oPRx9elTOIytWxb+C2Os8XVt3a71h+6UHWqtk5fLu8gspWmJNjQVyOff0LGa1UE0kPat
	 H2+2LBKFFohA/AVpPoUiCaYnilY5SW5Ehhk/lZs2jCSSQgaCKIfjb5p144dt9RDHzGZrz
	 Vc07I7/jE4vteDsmlYl718MkQ6zsTu24QsutIUSxmUa+xZ3g0sefGi0izZ1cYY02HsMVd
	 UiHBU8OWKPbMKCmNXHYqJmnGUnqe8fj3+baCs5DYVh3cHGiWkmRBezuh+XT+C5rM1Lwgc
	 oGV17jMSod5YDY3OPjrdGDglv37j7merVBEoRJhqR10ikWa2BBNp98Y0ioCF2beTq2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=71KtFVSLA+IF+2NekwxpGUATorZqO2cpi/1p1aTm0cE=;
	b=eJ+pqcO+GYm6/ycXL4bKLJRrK9lR88533Amua9PXw06SDv1qYcy0mdrkSEOoZCxs41a8
	 gbAK7R/btZnNxGMM2sQXTq3CFISLs56QXHbmx1rre7wbXo+AwQaF9/+59Cq/hcsT5XfHP
	 GFB4gbe5FRdO2TeZqopKP5wF0YQnz2UNxP+glXjoJoE/HSKdOCp455KkZfwSARSh7+aYR
	 AKWP0IwSimCeY8meq4rcREbgm4zfgbaRBCaQfd4kPHnyLUw+ie1mq0So9hdGqZLyBCedP
	 BQU+C/97jGzFIo5OqQg5cQVLL/09v/NSFoL/9LsdjLoAxHCy00ITf5Q0l6sVCtO6lhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pEFO801Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D468606A326;
	Sat,  7 Nov 2026 14:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pEFO801Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07B31F0089F;
	Sat,  7 Nov 2026 14:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061694;
	bh=71KtFVSLA+IF+2NekwxpGUATorZqO2cpi/1p1aTm0cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pEFO801ZGgQ2jMcd+sqd+HNVxMiqgUtwYAzXh2l3W8fJLamjuasuoRn/pOZrzsWlT
	 qYPbc70ILWlkg2uuo4YphQv5FznHftfhmDteUPs223B6O1OhCcPpq6mzVkoN0wYUmT
	 GgdpW4dPLJNy0+ZITYEUxamFww4GeIWpaQyBPIJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0706/1536] xfs: assign an owner to scrub_stats_fops
Date: Sat,  7 Nov 2026 08:45:22 -0500
Message-ID: <20261107135017.327339252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit fe67a493c7a76cf75556152af24285a114f69d34 upstream.

LOLLM complains that file_operations structs for debugfs files are
supposed to have an owner set so that the module can't get unloaded if
someone's sitting on a debugfs file long after unmount/rmmod.  Fix that.

Cc: stable@vger.kernel.org # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -290,6 +290,7 @@ out:
 }
 
 static const struct file_operations scrub_stats_fops = {
+	.owner			= THIS_MODULE,
 	.open			= simple_open,
 	.read			= xchk_scrub_stats_read,
 };
@@ -317,6 +318,7 @@ xchk_clear_scrub_stats_write(
 }
 
 static const struct file_operations clear_scrub_stats_fops = {
+	.owner			= THIS_MODULE,
 	.open			= simple_open,
 	.write			= xchk_clear_scrub_stats_write,
 };


