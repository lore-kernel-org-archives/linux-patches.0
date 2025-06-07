Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABF121A444;
	Sat,  7 Jun 2025 10:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291029; cv=none; b=AFxbu8TKNUGiE6q2L4MLXjaiczxNlG8mlDz7YDpPFI3VEDb/jAYDzgK+4ce8bv5M7Zwt3u19y4Q6ZtdhLDqVscc81/JITmkq37eCEigOFutiSxQcJodW86gP4CoVocUfmfFu1oPpKGoSv4WAgR+Z8SRpvnoeBj0mcKTcmpg0ipk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291029; c=relaxed/simple;
	bh=EIAlyLstKak8Y/4nr0C7lbDkdyruL3/+HI63KhcGF2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrjVlAwk/Kpi7FcZPlh7hMGuxWng5LZnEhh/e+OfQOCUbWurFniQAGLesOEQ4yqlIGdK2lzwPE+TIne8CGXzXIDO9gS/jUMxwvQa+4PYxVVSM4brpl/+RwhtS1kWXix24kLJdzTLRiyAnpitHP5yGJECQ2Cm/NA8Hcw7JFrXf5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3+NodLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3+NodLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F2DC4CEE4;
	Sat,  7 Jun 2025 10:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291029;
	bh=EIAlyLstKak8Y/4nr0C7lbDkdyruL3/+HI63KhcGF2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3+NodLWz1y1+Zu8GtBRoHzvHTPaSJ28MlEVqtsUhZ69hGIh7kl34LSSyTywAmbtx
	 HbfEXhKsY8SkzVxIGAWkXRjGBpHl8rI+xODVg2pLeg7SJs1vU20NIuLBl4/rRsMZKr
	 Z6LxkQ6lI0HSQQf7/4JrS49kjOSGN6ryXbAFqVz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.15 10/34] Documentation: ACPI: Use all-string data node references
Date: Sat,  7 Jun 2025 12:07:51 +0200
Message-ID: <20250607100720.127165969@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 6db0261f3776bde01ae916ad8e1cb2ded3ba1a2b upstream.

Document that references to data nodes shall use string-only references
instead of a device reference and a succession of the first package
entries of hierarchical data node references.

Fixes: 9880702d123f ("ACPI: property: Support using strings in reference properties")
Cc: 6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/20250409084738.3657079-1-sakari.ailus@linux.intel.com
[ rjw: Clarifying edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/firmware-guide/acpi/dsd/data-node-references.rst |   26 ++++------
 Documentation/firmware-guide/acpi/dsd/graph.rst                |   11 +---
 Documentation/firmware-guide/acpi/dsd/leds.rst                 |    7 --
 3 files changed, 17 insertions(+), 27 deletions(-)

--- a/Documentation/firmware-guide/acpi/dsd/data-node-references.rst
+++ b/Documentation/firmware-guide/acpi/dsd/data-node-references.rst
@@ -12,11 +12,14 @@ ACPI in general allows referring to devi
 Hierarchical data extension nodes may not be referred to directly, hence this
 document defines a scheme to implement such references.
 
-A reference consist of the device object name followed by one or more
-hierarchical data extension [dsd-guide] keys. Specifically, the hierarchical
-data extension node which is referred to by the key shall lie directly under
-the parent object i.e. either the device object or another hierarchical data
-extension node.
+A reference to a _DSD hierarchical data node is a string consisting of a
+device object reference followed by a dot (".") and a relative path to a data
+node object. Do not use non-string references as this will produce a copy of
+the hierarchical data node, not a reference!
+
+The hierarchical data extension node which is referred to shall be located
+directly under its parent object i.e. either the device object or another
+hierarchical data extension node [dsd-guide].
 
 The keys in the hierarchical data nodes shall consist of the name of the node,
 "@" character and the number of the node in hexadecimal notation (without pre-
@@ -33,11 +36,9 @@ extension key.
 Example
 =======
 
-In the ASL snippet below, the "reference" _DSD property contains a
-device object reference to DEV0 and under that device object, a
-hierarchical data extension key "node@1" referring to the NOD1 object
-and lastly, a hierarchical data extension key "anothernode" referring to
-the ANOD object which is also the final target node of the reference.
+In the ASL snippet below, the "reference" _DSD property contains a string
+reference to a hierarchical data extension node ANOD under DEV0 under the parent
+of DEV1. ANOD is also the final target node of the reference.
 ::
 
 	Device (DEV0)
@@ -76,10 +77,7 @@ the ANOD object which is also the final
 	    Name (_DSD, Package () {
 		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
 		Package () {
-		    Package () {
-			"reference", Package () {
-			    ^DEV0, "node@1", "anothernode"
-			}
+		    Package () { "reference", "^DEV0.ANOD" }
 		    },
 		}
 	    })
--- a/Documentation/firmware-guide/acpi/dsd/graph.rst
+++ b/Documentation/firmware-guide/acpi/dsd/graph.rst
@@ -66,12 +66,9 @@ of that port shall be zero. Similarly, i
 endpoint, the number of that endpoint shall be zero.
 
 The endpoint reference uses property extension with "remote-endpoint" property
-name followed by a reference in the same package. Such references consist of
-the remote device reference, the first package entry of the port data extension
-reference under the device and finally the first package entry of the endpoint
-data extension reference under the port. Individual references thus appear as::
+name followed by a string reference in the same package. [data-node-ref]::
 
-    Package() { device, "port@X", "endpoint@Y" }
+    "device.datanode"
 
 In the above example, "X" is the number of the port and "Y" is the number of
 the endpoint.
@@ -109,7 +106,7 @@ A simple example of this is show below::
 		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
 		Package () {
 		    Package () { "reg", 0 },
-		    Package () { "remote-endpoint", Package() { \_SB.PCI0.ISP, "port@4", "endpoint@0" } },
+		    Package () { "remote-endpoint", "\\_SB.PCI0.ISP.EP40" },
 		}
 	    })
 	}
@@ -141,7 +138,7 @@ A simple example of this is show below::
 		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
 		Package () {
 		    Package () { "reg", 0 },
-		    Package () { "remote-endpoint", Package () { \_SB.PCI0.I2C2.CAM0, "port@0", "endpoint@0" } },
+		    Package () { "remote-endpoint", "\\_SB.PCI0.I2C2.CAM0.EP00" },
 		}
 	    })
 	}
--- a/Documentation/firmware-guide/acpi/dsd/leds.rst
+++ b/Documentation/firmware-guide/acpi/dsd/leds.rst
@@ -15,11 +15,6 @@ Referring to LEDs in Device tree is docu
 "flash-leds" property documentation. In short, LEDs are directly referred to by
 using phandles.
 
-While Device tree allows referring to any node in the tree [devicetree], in
-ACPI references are limited to device nodes only [acpi]. For this reason using
-the same mechanism on ACPI is not possible. A mechanism to refer to non-device
-ACPI nodes is documented in [data-node-ref].
-
 ACPI allows (as does DT) using integer arguments after the reference. A
 combination of the LED driver device reference and an integer argument,
 referring to the "reg" property of the relevant LED, is used to identify
@@ -74,7 +69,7 @@ omitted. ::
 			Package () {
 				Package () {
 					"flash-leds",
-					Package () { ^LED, "led@0", ^LED, "led@1" },
+					Package () { "^LED.LED0", "^LED.LED1" },
 				}
 			}
 		})


