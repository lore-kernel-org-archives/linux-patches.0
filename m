Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE374746C9;
	Fri,  7 Aug 2026 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117326; cv=none; b=cdcSwPF5F7oDhgJ6onwz4BqOwwBPI6KHCua6+A7jAj5wBMKNDS8yylo5HjNyr8AN+iRRZX4tGjMFWEp80A4bfq5uY8gxUrobbTsM79Hv6hYoMw0GM/5Y8nur854hXXqimRZcB8lo0byEMRy7oX5fCmUdjpiRfQg7X6lAPUKa5/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117326; c=relaxed/simple;
	bh=OEt0OsLokYRIykakUgCQzS7yLdtW4jL4KLaQn6oEDR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsBQCP06KsZw3s5idN4ZtwA6Z0Vrer5GUaOArE8Go00qpyIU73/CNPXGSEi+VuMorubr9WKfUmAl+sUecqobxhVDeOHZCgT8Yqa7pdNPnZOSwS3LxWrsg+/lBiFKHMYFaoAG1hGpR74AKphRpo4fWA++HrWCcj7MmjPDot0ccyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyPGJc58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyPGJc58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2E81F000E9;
	Fri,  7 Aug 2026 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117324;
	bh=8+Taoti/H5vEWqDI2GPO6xtCtSJH2jHogcR15fJUkWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyPGJc58ycSEClfWJB0JGb7HIYfrN5x5Jzg2GGQZZVmp0kWbbymK4N/C9HkwUNZe+
	 fYN7JRMAZozExsLsdv+vWl9ZDS+WAznrZpOPt750JdwGChvSXg+x1ItpfNEEWJzFje
	 xkSCPe5dn4OoeFPH/bpOzPOat6ST5h/S9E0u560c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 7.1 279/438] mshv: fix hv_input_get_system_property struct
Date: Fri,  7 Aug 2026 16:37:55 +0200
Message-ID: <20260807143433.929071709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu@kernel.org>

commit d6f0248f04a96249660591e47fcf37ba98ac7ea3 upstream.

Keep it in sync with the correct definition.

The old code worked by chance.

Fixes: e68bda71a2384 ("hyperv: Add new Hyper-V headers in include/hyperv")
Cc: stable@kernel.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/hyperv/hvhdk_mini.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/hyperv/hvhdk_mini.h
+++ b/include/hyperv/hvhdk_mini.h
@@ -184,8 +184,9 @@ enum hv_dynamic_processor_feature_proper
 
 struct hv_input_get_system_property {
 	u32 property_id; /* enum hv_system_property */
+	u32 reserved;
 	union {
-		u32 as_uint32;
+		u64 as_uint64;
 #if IS_ENABLED(CONFIG_X86)
 		/* enum hv_dynamic_processor_feature_property */
 		u32 hv_processor_feature;


