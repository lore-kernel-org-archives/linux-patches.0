Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CFB1B2194;
	Wed, 19 Mar 2025 14:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394906; cv=none; b=Mx3qiMzbTAdZxRZCuk5989RwVJ3pPz9wboKzwglT1nniPbvjI2ijmq3vGqlPpyDAmJUJm7N5MShENXG+x+eudaq3OO0atKqUBDpBv7i8Cx+4wY19x8M6aXl2YkEmqHfTDySuVhXMtsaXotZrrz7nlU4WlfiUKOwYfU3rcnSZmBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394906; c=relaxed/simple;
	bh=OTDfvz1FpFyATERCkYMhJtGFaHTb/catgF+uVEiX17c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5pbUIwsbbVxqNBJxzi1foVf+V3D2uiEW4cayMMWiRAUtGXGoCimFsgV7rJm1GpjWzAk6CmwFGI5nR98KsNsJw5Ggp+eQ2TjwNncHhvamierTPI9dr88JBTDNnctWApMx/vGuEidvbDfibNMKDDNi5wjiWATQYrYXbtmyn/oAIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OegDKpii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OegDKpii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92DBC4CEE4;
	Wed, 19 Mar 2025 14:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394905;
	bh=OTDfvz1FpFyATERCkYMhJtGFaHTb/catgF+uVEiX17c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OegDKpii3FWXvP5wekmWM0PGITe2MGmPT2Mh3j+if8jI6kKkYAphb6fclCGFtOU//
	 aJlsj6vjU6stkST2OXU/VN0BMYVPpDfH5TLkZ6wDy3kNwAyitmfkp1SI+H3S3YrtXs
	 BhL1jmyfbkTLIEk0+5GyM0p7TruOWAo/8K0fTFc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 117/241] PCI: pci_ids: add INTEL_HDA_PTL_H
Date: Wed, 19 Mar 2025 07:29:47 -0700
Message-ID: <20250319143030.615861753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit a1f7b7ff0e10ae574d388131596390157222f986 ]

Add Intel PTL-H audio Device ID.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250210081730.22916-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index de5deb1a0118f..1a2594a38199f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3134,6 +3134,7 @@
 #define PCI_DEVICE_ID_INTEL_HDA_LNL_P	0xa828
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 #define PCI_DEVICE_ID_INTEL_HDA_BMG	0xe2f7
+#define PCI_DEVICE_ID_INTEL_HDA_PTL_H	0xe328
 #define PCI_DEVICE_ID_INTEL_HDA_PTL	0xe428
 #define PCI_DEVICE_ID_INTEL_HDA_CML_R	0xf0c8
 #define PCI_DEVICE_ID_INTEL_HDA_RKL_S	0xf1c8
-- 
2.39.5



