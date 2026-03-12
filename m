Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F9533F8A1;
	Thu, 12 Mar 2026 20:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346778; cv=none; b=Xte4sTvsMb+Bbzv3UF9IoCMEmFRWcsPiT9ClhU3Sp+2L+WfyCTb7xPzl+sZvDTTWWLoXtv47oFLGaL0a+iGW+m/YVguWQRVcOM9ok7MN4oBJDLnj2sbnsGimVPf7aUFe7dar8w+dUPyA/vwTpc9IVLSWGgnCGFmbJbDeYBTW/+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346778; c=relaxed/simple;
	bh=1s/f/08uVJlASpLzxp9ueaJ4gN5oWAoWs27zaqJt658=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQ+kvzs0/USvACDxFH25hjTk5/xetkm9EK1p4DwpsjpoOSwqCIRPiBAPzIUJoaAveh1ZdR2anId+UddnQ+1i+aaY7oh7DEqJ9Cn9ubO25OVMIzwdSwbJqS2xQcuHgx5r1zDdDcdieUkRHEpUttUGeAXYbQWD1EQ+HPcUvqkH/QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF80Gk6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF80Gk6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E87C4CEF7;
	Thu, 12 Mar 2026 20:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346778;
	bh=1s/f/08uVJlASpLzxp9ueaJ4gN5oWAoWs27zaqJt658=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SF80Gk6NZ/4cpZIOFhYj9apxaakIp877R7gOTeZgLaY5x95942+xhlZy22GnMdbkR
	 SVua2XpTDIfoDKcdxeqlY0QdlJqCSXj0X6dbrJ+JucZSL5sylw51/BF827LIs0p89V
	 av8QUhRa4M51NWw293iOATNB/XFxiCXsOu86dwkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Chen <chenste@linux.microsoft.com>,
	Baoquan He <bhe@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	Stefan Berger <stefanb@linux.ibm.com>
Subject: [PATCH 6.12 089/265] ima: rename variable the seq_file "file" to "ima_kexec_file"
Date: Thu, 12 Mar 2026 21:07:56 +0100
Message-ID: <20260312201021.435067214@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Chen <chenste@linux.microsoft.com>

[ Upstream commit cb5052282c65dc998d12e4eea8d5133249826c13 ]

Before making the function local seq_file "file" variable file static
global, rename it to "ima_kexec_file".

Signed-off-by: Steven Chen <chenste@linux.microsoft.com>
Acked-by: Baoquan He <bhe@redhat.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com> # ppc64/kvm
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Stable-dep-of: 10d1c75ed438 ("ima: verify the previous kernel's IMA buffer lies in addressable RAM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_kexec.c | 31 +++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index 9d45f4d26f731..650beb74346c5 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -18,30 +18,30 @@
 static int ima_dump_measurement_list(unsigned long *buffer_size, void **buffer,
 				     unsigned long segment_size)
 {
+	struct seq_file ima_kexec_file;
 	struct ima_queue_entry *qe;
-	struct seq_file file;
 	struct ima_kexec_hdr khdr;
 	int ret = 0;
 
 	/* segment size can't change between kexec load and execute */
-	file.buf = vmalloc(segment_size);
-	if (!file.buf) {
+	ima_kexec_file.buf = vmalloc(segment_size);
+	if (!ima_kexec_file.buf) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	file.file = NULL;
-	file.size = segment_size;
-	file.read_pos = 0;
-	file.count = sizeof(khdr);	/* reserved space */
+	ima_kexec_file.file = NULL;
+	ima_kexec_file.size = segment_size;
+	ima_kexec_file.read_pos = 0;
+	ima_kexec_file.count = sizeof(khdr);	/* reserved space */
 
 	memset(&khdr, 0, sizeof(khdr));
 	khdr.version = 1;
 	/* This is an append-only list, no need to hold the RCU read lock */
 	list_for_each_entry_rcu(qe, &ima_measurements, later, true) {
-		if (file.count < file.size) {
+		if (ima_kexec_file.count < ima_kexec_file.size) {
 			khdr.count++;
-			ima_measurements_show(&file, qe);
+			ima_measurements_show(&ima_kexec_file, qe);
 		} else {
 			ret = -EINVAL;
 			break;
@@ -55,23 +55,24 @@ static int ima_dump_measurement_list(unsigned long *buffer_size, void **buffer,
 	 * fill in reserved space with some buffer details
 	 * (eg. version, buffer size, number of measurements)
 	 */
-	khdr.buffer_size = file.count;
+	khdr.buffer_size = ima_kexec_file.count;
 	if (ima_canonical_fmt) {
 		khdr.version = cpu_to_le16(khdr.version);
 		khdr.count = cpu_to_le64(khdr.count);
 		khdr.buffer_size = cpu_to_le64(khdr.buffer_size);
 	}
-	memcpy(file.buf, &khdr, sizeof(khdr));
+	memcpy(ima_kexec_file.buf, &khdr, sizeof(khdr));
 
 	print_hex_dump_debug("ima dump: ", DUMP_PREFIX_NONE, 16, 1,
-			     file.buf, file.count < 100 ? file.count : 100,
+			     ima_kexec_file.buf, ima_kexec_file.count < 100 ?
+			     ima_kexec_file.count : 100,
 			     true);
 
-	*buffer_size = file.count;
-	*buffer = file.buf;
+	*buffer_size = ima_kexec_file.count;
+	*buffer = ima_kexec_file.buf;
 out:
 	if (ret == -EINVAL)
-		vfree(file.buf);
+		vfree(ima_kexec_file.buf);
 	return ret;
 }
 
-- 
2.51.0



