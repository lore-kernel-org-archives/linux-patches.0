Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8C76FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA44C433C8;
	Sun, 17 Sep 2023 20:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982803;
	bh=Fw9AN9siuQCMz9imNIdIN+f+TS6v3Z4FzoKoatleA0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTNOvM9Tx15nOkH8vaec9D97amtlm9Q+0276TlLejFRKgmXF2dT3foSKXGz6xQsbZ
	 uwN96QBoEC5nkscZ3qtT+ezjorj/w+gs7qKR1n3L3qKVz2SNpv5nA1aYpt/13LNB7n
	 4hpFqtLdV7pU4gJ2wL0M27BlixE5GYcd0g+13qXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 357/511] s390/ipl: add missing secure/has_secure file to ipl type unknown
Date: Sun, 17 Sep 2023 21:13:04 +0200
Message-ID: <20230917191122.421370206@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

commit ea5717cb13468323a7c3dd394748301802991f39 upstream.

OS installers are relying on /sys/firmware/ipl/has_secure to be
present on machines supporting secure boot. This file is present
for all IPL types, but not the unknown type, which prevents a secure
installation when an LPAR is booted in HMC via FTP(s), because
this is an unknown IPL type in linux. While at it, also add the secure
file.

Fixes: c9896acc7851 ("s390/ipl: Provide has_secure sysfs attribute")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/ipl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -502,6 +502,8 @@ static struct attribute_group ipl_ccw_at
 
 static struct attribute *ipl_unknown_attrs[] = {
 	&sys_ipl_type_attr.attr,
+	&sys_ipl_secure_attr.attr,
+	&sys_ipl_has_secure_attr.attr,
 	NULL,
 };
 


